/**
 * SwiftServe Cloud Functions
 *
 * Deploy with:
 *   cd functions && npm install
 *   firebase functions:secrets:set PAYSTACK_SECRET_KEY
 *   firebase deploy --only functions
 *
 * The Paystack secret key must live only in this server environment. Never
 * embed it in the Flutter app.
 */
const { onCall, onRequest, HttpsError } = require('firebase-functions/v2/https');
const { defineSecret } = require('firebase-functions/params');
const logger = require('firebase-functions/logger');
const admin = require('firebase-admin');
const crypto = require('crypto');

admin.initializeApp();

const paystackSecret = defineSecret('PAYSTACK_SECRET_KEY');
const db = admin.firestore();

const PAYSTACK_BASE_URL = 'https://api.paystack.co';

/**
 * Initializes a Paystack transaction and returns the hosted checkout URL.
 * Callable from the Flutter app via FirebaseFunctions.httpsCallable.
 */
exports.initializePayment = onCall(
  { secrets: [paystackSecret], cors: true },
  async (request) => {
    if (!request.auth) {
      throw new HttpsError('unauthenticated', 'Sign in to start a payment.');
    }

    const { amount, currency, email, reference, bookingId } = request.data || {};

    if (typeof amount !== 'number' || amount <= 0) {
      throw new HttpsError('invalid-argument', 'A positive amount is required.');
    }
    if (!email || !reference) {
      throw new HttpsError(
        'invalid-argument',
        'email and reference are required.',
      );
    }

    const response = await fetch(`${PAYSTACK_BASE_URL}/transaction/initialize`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${paystackSecret.value()}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        // Paystack expects the smallest currency unit (kobo for NGN).
        amount: Math.round(amount * 100),
        currency: currency || 'NGN',
        email,
        reference,
        metadata: {
          bookingId: bookingId || '',
          userId: request.auth.uid,
        },
      }),
    });

    const payload = await response.json();

    if (!response.ok || !payload.status) {
      logger.error('Paystack initialize failed', payload);
      throw new HttpsError(
        'internal',
        payload.message || 'Unable to initialize payment.',
      );
    }

    await db.collection('transactions').doc(reference).set(
      {
        reference,
        amount,
        currency: currency || 'NGN',
        method: 'card',
        status: 'processing',
        bookingId: bookingId || '',
        userId: request.auth.uid,
        authorizationUrl: payload.data.authorization_url,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    return {
      reference,
      authorizationUrl: payload.data.authorization_url,
      accessCode: payload.data.access_code,
    };
  },
);

/**
 * Paystack webhook. Verifies the transaction and marks the booking as paid.
 * Configure the webhook URL in the Paystack dashboard after deployment.
 */
exports.paystackWebhook = onRequest(
  { secrets: [paystackSecret] },
  async (req, res) => {
  if (req.method !== 'POST') {
    res.status(405).send('Method not allowed');
    return;
  }

  // Verify the request really came from Paystack.
  const signature = req.headers['x-paystack-signature'];
  const expected = crypto
    .createHmac('sha512', paystackSecret.value())
    .update(req.rawBody)
    .digest('hex');

  if (!signature || signature !== expected) {
    res.status(401).send('invalid signature');
    return;
  }

  const event = req.body;
  if (!event || event.event !== 'charge.success') {
    res.status(200).send('ignored');
    return;
  }

  const reference = event.data && event.data.reference;
  if (!reference) {
    res.status(400).send('missing reference');
    return;
  }

  try {
    const verifyResponse = await fetch(
      `${PAYSTACK_BASE_URL}/transaction/verify/${encodeURIComponent(reference)}`,
      {
        headers: {
          Authorization: `Bearer ${paystackSecret.value()}`,
        },
      },
    );
    const verified = await verifyResponse.json();

    if (!verified.status || verified.data.status !== 'success') {
      logger.warn('Unverified Paystack webhook', { reference });
      res.status(400).send('verification failed');
      return;
    }

    const transactionRef = db.collection('transactions').doc(reference);
    const snapshot = await transactionRef.get();
    const bookingId = snapshot.exists ? snapshot.data().bookingId : '';

    await transactionRef.set(
      {
        status: 'successful',
        paidAt: admin.firestore.FieldValue.serverTimestamp(),
      },
      { merge: true },
    );

    if (bookingId) {
      await db.collection('bookings').doc(bookingId).update({
        status: 'Confirmed',
        paymentStatus: 'paid',
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    res.status(200).send('ok');
  } catch (error) {
    logger.error('Paystack webhook error', error);
    res.status(500).send('error');
  }
  },
);
