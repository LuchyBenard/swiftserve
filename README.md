# ⚡ SwiftServe

An on-demand service booking and marketplace mobile application built with **Flutter** and **Firebase**. **SwiftServe** bridges the gap between clients and skilled freelance professionals (barbers, phone/tech repair specialists, stylists, plumbers, electricians, mechanics, and more), offering a streamlined, real-time booking and job tracking experience.

> **Status:** Functional Flutter app with live Firebase authentication, Firestore-backed chat, bookings, and provider directory, plus Cloud Storage uploads, FCM scaffolding, Paystack payment functions, Firestore/Storage security rules, and CI. Remaining demo areas are called out in [Implementation Status](#-implementation-status) and [Known Limitations](#-known-limitations).

---

## 📱 Features Overview

### 👤 Client Experience
- **Interactive Onboarding & Welcome:** Engaging onboarding flow featuring smooth page indicators and liquid swipe transitions.
- **Service Discovery & Search:** Browse diverse service categories (e.g., Tech Repair, Barbering, Styling, Plumbing) with real-time text search and filters. *Providers load from Firestore with a curated seed fallback.*
- **Advanced Search & Filter:** Dynamic modal bottom sheet to filter providers by minimum rating (4.0+, 4.5+, 4.8+), price cap, maximum distance, and availability today, plus multi-criteria sorting (Rating, Price, Distance).
- **Favorites & Saved Providers:** Heart and bookmark favorite service professionals directly from cards or profiles, with reactive local persistence and a dedicated "Saved Providers" screen.
- **Address & GPS Location Picker:** Manage multiple saved addresses (Home, Work, Other) or auto-detect current coordinates via a simulated satellite GPS lookup.
- **Provider Profiles & Portfolios:** Comprehensive provider profiles displaying ratings, review counts, distances, hourly/base pricing, bios, and service offerings.
- **Multi-Step Booking Flow:**
  - **Step 1 — Details:** Select services, specify address with location picker, and describe requirements.
  - **Step 2 — Schedule:** Choose booking date and convenient time slots.
  - **Step 3 — Review & Checkout:** Verify request details, view cost breakdowns, and finalize booking.
- **Job Tracking UI:** Monitor ongoing service requests with status stages (`In Progress`, `Confirmed`, `Completed`, `Canceled`). *Provider status changes are written to Firestore.*
- **Booking History:** Switch between active and past bookings, re-open job tracking, leave ratings, or cancel upcoming appointments. *Firestore-backed with a seeded local fallback.*
- **Structured Booking Cancellation:** Cancel active bookings through a dedicated modal with categorized reasons and notes.
- **Interactive Chat & Direct Messaging:**
  - Real-time 1-on-1 direct messaging between clients and service providers, backed by Cloud Firestore.
  - Graceful in-memory fallback when Firebase is unavailable (tests/offline preview), so the app never crashes on startup.
  - Realistic provider typing status indicator and intelligent auto-reply simulation engine.
  - Quick actions bottom sheet for camera capture, gallery photo attachments, GPS location sharing, and preset replies.
  - Full-screen media preview viewer and one-tap provider voice dialing.
  - Direct messaging entry points from Provider Profile (`ProviderDetailsPage`) and Job Tracking (`JobTrackingPage`).
  - Real-time unread badges on `ChatInboxPage` and navigation bar, search filtering, and swipe-to-delete conversation management.
- **In-App Notification Center & Alerts:**
  - Dedicated notification hub with real-time unread counter badge on `HomePage` header and `ProfilePage`.
  - Category filtering across **All**, **Bookings**, **Payments**, **Promos**, and **Alerts**.
  - One-tap "Mark all as read" action and swipe-to-delete gesture removal with reactive offline persistence.
  - Custom floating in-app alert banner system for high-priority status updates and provider replies.
  - Granular notification preferences modal for toggling push, booking alerts, promotional deals, and alert sounds. *Preferences are local; FCM delivery is scaffolded.*
- **Ratings & Reviews:** Leave 5-star ratings and written feedback once a job is complete. *UI only — reviews are not yet persisted to Firestore.*
- **Profile & History:** Manage personal details, saved addresses, favorite providers, and historical bookings.

### 🛠️ Service Provider Portal
- **Provider Registration:** Onboarding workflow for professionals to submit their category, experience, base rates, bio, and location. *Writes to Firestore on sign-up.*
- **Verification Upload UI:** Screen for submitting verification documents. *Uploads to Firebase Storage and submits `verificationStatus: pending`.*
- **Dedicated Dashboard:** Bottom navigation optimized for providers (Active Jobs, Schedule, Earnings, Availability).
- **Active Jobs Management:** View and manage incoming client requests. *Firestore-backed with seeded fallback; accept/start/complete update booking status.*
- **Schedule & Availability:** Configure work schedules and toggle real-time availability. *UI state only, not yet persisted.*
- **Earnings & Analytics:** Track revenue, completed jobs, and detailed transaction histories. *Static demo charts; withdrawal is simulated.*

### 🛡️ Admin & Moderation Suite
- **Admin Dashboard:** High-level overview of platform metrics, active jobs, and users. *Demo metrics.*
- **Provider Moderation:** Review incoming worker registrations and approve or reject provider profiles. *UI flow with demo reports.*
- **User Management:** Manage client and provider accounts across the platform. *Demo list.*
- **Access:** Reachable from `ProfilePage` via the **Admin Portal** toggle.

### 🔐 Authentication & Security
- **Role-Based Routing (`AuthGate`):** Dynamically steers users to Client or Provider workspaces based on their Firestore role profile.
- **Multiple Sign-In Options:**
  - Email & Password authentication.
  - Google Sign-In integration.
  - Apple Sign-In support.
- **Account Recovery:** Forgot password, OTP verification, and password reset workflows.

---

## 📊 Implementation Status

| Area | Status | Notes |
| --- | --- | --- |
| Authentication (email, Google, Apple) | ✅ Live | Firebase Auth |
| Role-based routing (`users.role`) | ✅ Live | Firestore profile lookup |
| Provider registration | ✅ Live | Writes `users` + `providers` |
| Direct messaging | ✅ Live | Cloud Firestore + local fallback |
| Favorites & saved addresses | ✅ Local | `shared_preferences` |
| Provider discovery | ✅ Live | Firestore `providers` query + curated seed fallback |
| Bookings & history | ✅ Live | Firestore `bookings` + local seed fallback |
| Real-time job status | ✅ Live | Provider Accept → Start → Complete writes booking status |
| Client job tracking UI | 🟡 Partial | Timeline still advances visually; status comes from the booking |
| Checkout & payments | 🟡 Scaffolded | Mock gateway offline; Paystack Cloud Function + webhook included |
| Push notifications | 🟡 Scaffolded | FCM client, token persistence, foreground routing; needs project config |
| Notification center | ✅ Live | Local persistence + FCM foreground messages |
| Image & document upload | ✅ Live | Firebase Storage with local-path fallback |
| Provider verification | ✅ Live | ID upload + `verificationStatus: pending` submission |
| Firestore & Storage rules | ✅ Added | `firestore.rules`, `storage.rules` — deploy to enforce |
| CI pipeline | ✅ Added | GitHub Actions: format, analyze, test, rules compile |
| Provider earnings & schedule | 🟡 Demo | Static charts/state |
| Admin dashboard & moderation | 🟡 Demo | Demo metrics, placeholder Providers tab |
| Ratings & reviews | 🟡 UI only | Rules exist; app does not persist reviews yet |
| Maps & real GPS | ⛔ Missing | Add `geolocator` / map provider |
| Wallet, promos & refunds | ⛔ Missing | Needs gateway + ledger work |

---

## 🗺️ Roadmap & Suggested Features

The following features would move SwiftServe from prototype to production. Ordered by impact.

### ✅ Delivered in this iteration
1. **Firestore booking service** — `bookings` collection, real-time client/provider streams, create/update/cancel, seeded local fallback.
2. **Firestore & Storage security rules** — owner/participant access, admin custom claims, per-folder storage limits.
3. **Provider directory from Firestore** — category and verified-provider queries, composite indexes, curated seed fallback.
4. **Payments scaffolding** — pluggable gateway, mock offline mode, Paystack `initializePayment` and signed webhook Cloud Functions, transaction records.
5. **Push notifications** — FCM client, permission/token handling, token persistence, foreground messages routed into the in-app notification center.
6. **Cloud file uploads** — profile avatars, chat attachments, and provider verification documents via Firebase Storage.
7. **Provider job actions** — Accept → Start → Complete updates the shared booking document.
8. **CI pipeline** — GitHub Actions for formatting, analysis, tests, and Firebase rules compilation.

### 🔴 Next / must-have
9. **Deploy & configure** — create the Firebase project, deploy rules/indexes/functions, set `PAYSTACK_SECRET_KEY`, and add APNs/FCM credentials.
10. **Ratings & reviews persistence** — write reviews to Firestore, recompute provider averages, and gate submission on completed bookings.
11. **Client tracking live status** — drive the client timeline from booking status instead of the local simulation.
12. **Payment receipts & refunds** — handle webhook retries, receipts, escrow/hold, cancellation fees, and refund flows.
13. **Admin approvals that write back** — approval/rejection updates `providers.isVerified` and notifies the provider.

### 🟠 High value
14. **Maps & live location** — `geolocator` + map SDK for provider search radius, address pinning, and "provider on the way" tracking.
15. **Provider availability & scheduling persistence** — save weekly availability and block out booked slots; prevent double-booking.
16. **In-app calling / masked numbers** — replace the mock dialer with a privacy-preserving call flow.
17. **Wallet, promos & refunds** — in-app wallet balance, promo codes, and cancellation fee rules.
18. **Search & geo queries at scale** — Algolia/Typesense or Firestore geohash queries, plus debounced search.
19. **Session & error handling** — friendly offline/error states, retry logic, and token refresh handling.

### 🟢 Nice-to-have
20. **Recurring bookings & favourites re-book** — one-tap rebooking and subscription-style schedules.
21. **Multi-language & multi-currency** — `flutter_localizations` + `intl` with per-region pricing.
22. **Theming** — centralize brand colors in `lib/theme/app_colors.dart` and ship a true `darkTheme` + `themeMode`.
23. **Accessibility & localization** — semantic labels, dynamic type, contrast checks.
24. **Crash & analytics monitoring** — Firebase Crashlytics/Analytics or Sentry.
25. **End-to-end tests** — integration tests for booking, chat, and payment flows.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev) / [Dart](https://dart.dev) (Dart SDK `^3.10.7`)
- **Backend & Cloud Services:**
  - **Firebase Authentication:** Secure user identity management and social logins.
  - **Cloud Firestore:** Real-time NoSQL cloud database for users, providers, bookings, conversations, messages, and transactions.
  - **Firebase Storage:** Profile avatars, chat attachments, portfolio images, and verification documents.
  - **Firebase Cloud Messaging:** Push notification client with token persistence and foreground routing.
  - **Cloud Functions (Node 20):** Paystack payment initialization and signed webhook verification.
- **UI & UX:**
  - Modern dark mode aesthetic with vibrant neon green accent (`#25F46A`) and purple splash branding (`#4A148C`).
  - [Google Fonts](https://pub.dev/packages/google_fonts) for typography.
  - [Liquid Swipe](https://pub.dev/packages/liquid_swipe) & [Smooth Page Indicator](https://pub.dev/packages/smooth_page_indicator) for interactive onboarding.
  - Custom geometric clippers and glassmorphic overlay effects.
  - [Flutter Native Splash](https://pub.dev/packages/flutter_native_splash) for splash screen generation.
- **Native & Utility Packages:**
  - [Image Picker](https://pub.dev/packages/image_picker): Profile picture, chat attachments, and verification uploads.
  - [Firebase Storage](https://pub.dev/packages/firebase_storage) & [Firebase Messaging](https://pub.dev/packages/firebase_messaging): Uploads and push notifications.
  - [Cloud Functions](https://pub.dev/packages/cloud_functions): Callable payment initialization.
  - [URL Launcher](https://pub.dev/packages/url_launcher): Dialing, emailing, and opening external URLs.
  - [Shared Preferences](https://pub.dev/packages/shared_preferences): Local persistence for onboarding completion, favorites, addresses, chats, and notifications.
  - [Google Sign-In](https://pub.dev/packages/google_sign_in) & [Sign in with Apple](https://pub.dev/packages/sign_in_with_apple): Social authentication.

> **Still not integrated:** maps/real GPS, wallet/promos/refunds, and Crashlytics. See the roadmap above.

### 🗄️ Firestore Data Model

**Implemented**

| Collection | Purpose |
| --- | --- |
| `users/{uid}` | Account profile, `role` (`client` or `provider`), avatar, and FCM token |
| `providers/{uid}` | Provider profile, category, rates, verification and availability state |
| `bookings/{id}` | Service request, schedule, status, pricing and participants |
| `transactions/{id}` | Payment reference, amount, method, status and booking link |
| `conversations/{id}` | Chat metadata, participants, last message and read state |
| `conversations/{id}/messages` | Individual chat messages ordered by timestamp |

**Planned**

| Collection | Purpose |
| --- | --- |
| `reviews/{id}` | Rating, comment, reviewer and provider references (rules exist, app write pending) |
| `notifications/{id}` | Server-generated user notifications for FCM delivery |

**Storage layout**

| Path | Purpose |
| --- | --- |
| `users/{uid}/avatar/...` | Profile pictures |
| `verification/{uid}/...` | Provider ID and verification documents |
| `providers/{uid}/...` | Provider portfolio images |
| `chat/{conversationId}/...` | Chat image attachments |

---

## 📂 Project Structure

```text
swiftserve/
├── android/                        # Native Android configuration
├── ios/                            # Native iOS configuration
├── assets/                         # Static assets & images
│   └── images/                     # App icons, avatars & onboarding artwork
├── lib/
│   ├── firebase_options.dart       # Firebase initialization configuration
│   ├── main.dart                   # Application entrypoint & global theme
│   ├── models/                     # Data transfer objects & entity models
│   │   ├── app_notification.dart   # In-app notifications & settings models
│   │   ├── booking.dart            # Booking state and metadata
│   │   ├── conversation.dart       # Chat inbox conversations
│   │   ├── message.dart            # Individual chat messages
│   │   ├── provider.dart           # Service provider profile model
│   │   ├── provider_filter.dart    # Filter & sorting criteria model
│   │   ├── saved_address.dart      # Saved service address model
│   │   └── user.dart               # User account model
│   ├── onboarding/                 # Onboarding walkthrough screens
│   ├── pages/                      # UI screens and navigation flows
│   │   ├── admin/                  # Admin dashboard, moderation & user management
│   │   ├── auth/                   # Sign-up, forgot/reset password, OTP & worker registration
│   │   ├── provider/               # Provider jobs, schedule, earnings, availability & verification
│   │   ├── rating/                 # Review & rating submission
│   │   ├── request/                # Multi-step service request & checkout flow
│   │   ├── tracking/               # Job status tracking
│   │   ├── booking_page.dart       # Bookings list page
│   │   ├── bottomnav.dart          # Client bottom navigation shell
│   │   ├── chat_inbox_page.dart    # Recent conversations inbox
│   │   ├── chat_page.dart          # Direct message chat room
│   │   ├── history_page.dart       # Active & past booking history
│   │   ├── homepage.dart           # Main client dashboard & categories
│   │   ├── notification_center_page.dart # In-app notification center & alerts
│   │   ├── profile_page.dart       # User profile management & admin entry
│   │   ├── provider_details_page.dart    # Provider profile & portfolio
│   │   ├── provider_list_page.dart # Search & filtered provider directory
│   │   └── saved_providers_page.dart     # Dedicated favorite providers view
│   ├── services/                   # External services & business logic
│   │   ├── address_service.dart    # Saved addresses & GPS auto-detection
│   │   ├── auth_service.dart       # Firebase Auth & Firestore user sync
│   │   ├── booking_service.dart    # Firestore bookings, streams & local fallback
│   │   ├── chat_service.dart       # Direct messaging, reactive streams & auto-replies
│   │   ├── favorites_service.dart  # Favorite provider persistence & reactive state
│   │   ├── notification_service.dart # Reactive notifications, unread state & alerts
│   │   ├── payment_service.dart    # Gateway abstraction, mock + Paystack function
│   │   ├── provider_service.dart   # Firestore provider directory & seed fallback
│   │   ├── push_notification_service.dart # FCM permissions, tokens & foreground routing
│   │   └── storage_service.dart    # Firebase Storage uploads & local fallback
│   ├── splash/                     # Startup splash screen
│   ├── welcome/                    # Welcome & sign-in screen
│   └── widgets/                    # Reusable widgets
│       ├── clippers/               # Geometric and wave shape clippers
│       ├── address_picker_sheet.dart # Bottom sheet for location selection
│       ├── auth_gate.dart          # Role-based route gatekeeper
│       ├── cancel_booking_dialog.dart # Booking cancellation modal
│       ├── provider_bottom_nav.dart # Provider navigation bar
│       └── provider_filter_sheet.dart # Filter & sort bottom sheet
├── functions/                      # Cloud Functions (Paystack init + webhook)
│   ├── index.js                    # initializePayment & paystackWebhook
│   └── package.json                # Node 20 function dependencies
├── .github/workflows/ci.yml        # Format, analyze, test & rules compile
├── firestore.rules                 # Firestore security rules
├── firestore.indexes.json          # Composite indexes for bookings/providers
├── storage.rules                   # Storage security rules
├── firebase.json                   # Firebase CLI configuration
├── test/                           # Unit and widget tests
├── pubspec.yaml                    # Project dependencies and asset definitions
└── README.md                       # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (includes Dart `3.10.7` or higher)
- [Dart SDK](https://dart.dev/get-dart)
- An active [Firebase Project](https://console.firebase.google.com/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) for Firebase setup
- Xcode (for iOS/macOS) and/or Android Studio (for Android)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/LuchyBenard/swiftserve.git
   cd swiftserve
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   Generate the required `lib/firebase_options.dart` and platform files using the FlutterFire CLI:
   ```bash
   flutterfire configure
   ```
   *Enable **Authentication** (Email, Google, Apple), **Cloud Firestore**, **Storage**, and **Cloud Messaging** in your Firebase Console.*

4. **Set your Firebase project id:**
   Update `.firebaserc` (replace `swiftserve-REPLACE_ME`) or run:
   ```bash
   firebase use --add
   ```

5. **Deploy Firestore/Storage rules and indexes:**
   ```bash
   firebase deploy --only firestore:rules,firestore:indexes,storage
   ```

6. **Deploy Cloud Functions (payments):**
   ```bash
   cd functions
   npm install
   firebase functions:secrets:set PAYSTACK_SECRET_KEY
   cd ..
   firebase deploy --only functions
   ```
   Add the deployed `paystackWebhook` URL to your Paystack dashboard, and keep the secret key server-side only.

7. **Configure push notifications:**
   - Android: add `google-services.json` and the FCM setup from FlutterFire.
   - iOS: upload an APNs key in Firebase Console and enable the Push Notifications capability.
   - Cloud Functions can target stored `users/{uid}.fcmToken` values or role topics (`clients`, `providers`).

8. **Run native splash generator (optional, if assets were modified):**
   ```bash
   dart run flutter_native_splash:create
   ```

9. **Run the application:**
   ```bash
   flutter run
   ```

> **Offline/demo mode:** If Firebase is not configured, chat, bookings, providers, and storage automatically fall back to in-memory/local data so the app and tests still run. Card payments use the mock gateway; cash and bank transfer record pending transactions.

---

## 🧪 Testing & Code Quality

- **Run widget and unit tests:**
  ```bash
  flutter test
  ```

  The current suite covers **30 passing tests**:
  - Model serialization (`User`, `Provider`, `Booking`, `Message`, `Conversation`, `SavedAddress`, `ProviderFilter`, `AppNotification`)
  - Favorites and saved provider persistence
  - Advanced provider filtering and sorting
  - Address presets and GPS detection
  - Booking cancellation dialog and wave clipper widgets
  - Chat service messaging, unread counts, and `ChatPage` rendering
  - Notification service lifecycle and `NotificationCenterPage` rendering
  - Booking service create/update/cancel and local fallback
  - Payment service cash and mock card flows
  - Provider directory seed fallback and featured providers

- **Run static code analysis:**
  ```bash
  flutter analyze
  ```

  The project currently reports **no analyzer issues** (0 errors, 0 warnings, 0 infos).

- **Format Dart code:**
  ```bash
  dart format .
  ```

- **CI:** `.github/workflows/ci.yml` runs formatting checks, `flutter analyze`, `flutter test`, and compiles the Firestore/Storage rules with the Firebase emulators on every push and pull request to `main`.

---

## ⚠️ Known Limitations

- **Payments require deployment:** the Flutter side calls a `initializePayment` Cloud Function. Without a deployed function and `PAYSTACK_SECRET_KEY`, card payments fail gracefully; cash/bank transfers record pending transactions only.
- **Push requires platform setup:** FCM tokens are stored, but delivery depends on APNs/FCM credentials and server-side senders.
- **Provider earnings, schedule, admin metrics, and moderation** still use demo data.
- **Ratings & reviews** remain UI-only; the Firestore rules exist but the app does not write reviews yet.
- **GPS detection is simulated** rather than using the device location.
- **Client job-tracking timeline** still advances visually; provider status changes are the source of truth.
- **Provider discovery** falls back to curated seed data when Firestore has no matching records.
- **Navigation and some provider imagery** still use remote placeholder URLs.
- **Security rules and indexes must be deployed** (`firebase deploy`) to take effect; the repository includes them but deployment is environment-specific.
- **CI does not publish builds** yet — it runs formatting, analysis, tests, and rules compilation.

---

## 👥 User Roles & Flow

```
                    ┌──────────────────────┐
                    │    Splash Screen     │
                    └──────────┬───────────┘
                               │
                        [AuthGate Check]
                         /            \
                 (Logged Out)       (Logged In)
                     /                    \
     ┌───────────────────────┐      ┌──────────────┐
     │ Onboarding / Welcome  │      │ Check Role   │
     └──────────┬────────────┘      └──────┬───────┘
                │                          │
     ┌───────────────────────┐      ┌──────┴───────┐
     │  Sign In / Register   │      │              │
     │  (Client or Provider) │   [Client]     [Provider]
     └───────────────────────┘      │              │
                          ┌─────────┴─────┐  ┌─────┴───────────────┐
                          │ Client Home   │  │ Provider Dashboard  │
                          │ • Browse      │  │ • Active Jobs       │
                          │ • Book        │  │ • Availability      │
                          │ • Track       │  │ • Earnings          │
                          │ • Chat        │  │ • Schedule          │
                          └───────────────┘  └─────────────────────┘
```

---

## 📄 License

This project is licensed under the MIT License.
