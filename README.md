# ⚡ SwiftServe

An on-demand service booking and marketplace mobile application built with **Flutter** and **Firebase**. **SwiftServe** bridges the gap between clients and skilled freelance professionals (barbers, phone/tech repair specialists, stylists, plumbers, electricians, mechanics, and more), offering a streamlined, real-time booking and job tracking experience.

> **Status:** Functional UI prototype with live Firebase authentication and Firestore-backed chat. Several commerce flows (bookings, payments, provider discovery, admin) currently use demo data — see [Implementation Status](#-implementation-status) and [Roadmap](#-roadmap--suggested-features).

---

## 📱 Features Overview

### 👤 Client Experience
- **Interactive Onboarding & Welcome:** Engaging onboarding flow featuring smooth page indicators and liquid swipe transitions.
- **Service Discovery & Search:** Browse diverse service categories (e.g., Tech Repair, Barbering, Styling, Plumbing) with real-time text search and filters. *Directory currently uses demo providers.*
- **Advanced Search & Filter:** Dynamic modal bottom sheet to filter providers by minimum rating (4.0+, 4.5+, 4.8+), price cap, maximum distance, and availability today, plus multi-criteria sorting (Rating, Price, Distance).
- **Favorites & Saved Providers:** Heart and bookmark favorite service professionals directly from cards or profiles, with reactive local persistence and a dedicated "Saved Providers" screen.
- **Address & GPS Location Picker:** Manage multiple saved addresses (Home, Work, Other) or auto-detect current coordinates via a simulated satellite GPS lookup.
- **Provider Profiles & Portfolios:** Comprehensive provider profiles displaying ratings, review counts, distances, hourly/base pricing, bios, and service offerings.
- **Multi-Step Booking Flow:**
  - **Step 1 — Details:** Select services, specify address with location picker, and describe requirements.
  - **Step 2 — Schedule:** Choose booking date and convenient time slots.
  - **Step 3 — Review & Checkout:** Verify request details, view cost breakdowns, and finalize booking.
- **Job Tracking UI:** Monitor ongoing service requests with status stages (`In Progress`, `Confirmed`, `Completed`, `Canceled`). *Status changes are simulated.*
- **Booking History:** Switch between active and past bookings, re-open job tracking, leave ratings, or cancel upcoming appointments. *Populated with demo bookings.*
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
  - Granular notification preferences modal for toggling push, booking alerts, promotional deals, and alert sounds. *Local preferences only — no push delivery yet.*
- **Ratings & Reviews:** Leave 5-star ratings and written feedback once a job is complete. *UI only — reviews are not yet persisted to Firestore.*
- **Profile & History:** Manage personal details, saved addresses, favorite providers, and historical bookings.

### 🛠️ Service Provider Portal
- **Provider Registration:** Onboarding workflow for professionals to submit their category, experience, base rates, bio, and location. *Writes to Firestore on sign-up.*
- **Verification Upload UI:** Screen for submitting verification documents. *Capture only — file upload/storage pending.*
- **Dedicated Dashboard:** Bottom navigation optimized for providers (Active Jobs, Schedule, Earnings, Availability).
- **Active Jobs Management:** View and manage incoming client requests. *Demo data; accept/status updates are local only.*
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
| Notification center | 🟡 Local only | Persisted locally; no push/FCM |
| Provider discovery | 🟡 Demo | Mock providers in `provider_list_page.dart` |
| Bookings & history | 🟡 Demo | In-memory sample bookings |
| Job tracking | 🟡 Demo | Simulated status stages |
| Checkout & payments | 🟡 Demo | Cash/bank selection only, no gateway |
| Provider earnings & schedule | 🟡 Demo | Static charts/state |
| Admin dashboard & moderation | 🟡 Demo | Demo metrics, placeholder Providers tab |
| Ratings & reviews | 🟡 UI only | Not persisted |
| Firestore security rules | ⛔ Missing | Must be added before production |
| Push notifications | ⛔ Missing | Add `firebase_messaging` |
| Image/file storage | ⛔ Missing | Add `firebase_storage` |
| Payments integration | ⛔ Missing | Paystack / Flutterwave / Stripe |
| Maps & real GPS | ⛔ Missing | Add `geolocator` / map provider |
| CI & release pipeline | ⛔ Missing | Add GitHub Actions |

---

## 🗺️ Roadmap & Suggested Features

The following features would move SwiftServe from prototype to production. Ordered by impact.

### 🔴 Core / must-have
1. **Booking service backed by Firestore** — replace demo bookings with a `bookings` collection, real-time status streams, and client/provider views driven by shared data.
2. **Firestore security rules** — restrict `users`, `providers`, `bookings`, `conversations`, and `messages` to the authenticated owner/participant; lock down admin-only writes.
3. **Provider directory from Firestore** — load real providers, reviews, and availability instead of `_getMockProviders()`; add pagination and category indexes.
4. **Payments** — integrate a gateway (Paystack/Flutterwave for NGN, Stripe internationally), add payment intents, escrow/hold, receipts, and refunds. Replace the simulated withdrawal.
5. **Push notifications** — add `firebase_messaging` + FCM topics per user/role, deep links into chat/bookings, and Cloud Functions to emit events.
6. **Image & document upload** — add `firebase_storage` for avatars, portfolio photos, chat attachments, and provider verification documents.
7. **Ratings & reviews persistence** — store reviews in Firestore, recompute provider averages, and gate review submission on completed bookings.
8. **Real-time job status** — provider-side accept/start/complete actions that update the same booking document the client is tracking.

### 🟠 High value
9. **Maps & live location** — `geolocator` + map SDK for provider search radius, address pinning, and "provider on the way" tracking.
10. **Provider availability & scheduling persistence** — save weekly availability and block out booked slots; prevent double-booking.
11. **In-app calling / masked numbers** — replace the mock `+2348001234567` dialer with a privacy-preserving call flow.
12. **Admin approvals that write back** — approval/rejection updates `providers.isVerified` and notifies the provider.
13. **Wallet, promos & refunds** — in-app wallet balance, promo codes, and cancellation fee rules.
14. **Search & geo queries at scale** — Algolia/Typesense or Firestore geohash queries, plus debounced search.
15. **Session & error handling** — friendly offline/error states, retry logic, and token refresh handling.

### 🟢 Nice-to-have
16. **Recurring bookings & favourites re-book** — one-tap rebooking and subscription-style schedules.
17. **Multi-language & multi-currency** — `flutter_localizations` + `intl` with per-region pricing.
18. **Theming** — centralize brand colors in `lib/theme/app_colors.dart` and ship a true `darkTheme` + `themeMode`.
19. **Accessibility & localization** — semantic labels, dynamic type, contrast checks.
20. **Crash & analytics monitoring** — Firebase Crashlytics/Analytics or Sentry.
21. **CI/CD** — GitHub Actions running `flutter analyze`, `flutter test`, and signed builds.
22. **End-to-end tests** — integration tests for booking, chat, and payment flows.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev) / [Dart](https://dart.dev) (Dart SDK `^3.10.7`)
- **Backend & Cloud Services:**
  - **Firebase Authentication:** Secure user identity management and social logins.
  - **Cloud Firestore:** Real-time NoSQL cloud database for users, providers, conversations, and messages.
- **UI & UX:**
  - Modern dark mode aesthetic with vibrant neon green accent (`#25F46A`) and purple splash branding (`#4A148C`).
  - [Google Fonts](https://pub.dev/packages/google_fonts) for typography.
  - [Liquid Swipe](https://pub.dev/packages/liquid_swipe) & [Smooth Page Indicator](https://pub.dev/packages/smooth_page_indicator) for interactive onboarding.
  - Custom geometric clippers and glassmorphic overlay effects.
  - [Flutter Native Splash](https://pub.dev/packages/flutter_native_splash) for splash screen generation.
- **Native & Utility Packages:**
  - [Image Picker](https://pub.dev/packages/image_picker): Profile picture and verification uploads.
  - [URL Launcher](https://pub.dev/packages/url_launcher): Dialing, emailing, and opening external URLs.
  - [Shared Preferences](https://pub.dev/packages/shared_preferences): Local persistence for onboarding completion, favorites, addresses, chats, and notifications.
  - [Google Sign-In](https://pub.dev/packages/google_sign_in) & [Sign in with Apple](https://pub.dev/packages/sign_in_with_apple): Social authentication.

> **Not yet integrated:** payments, maps/geolocation, push messaging, and cloud file storage. See the roadmap above.

### 🗄️ Firestore Data Model

**Implemented**

| Collection | Purpose |
| --- | --- |
| `users/{uid}` | Account profile and `role` (`client` or `provider`) used by `AuthGate` |
| `providers/{uid}` | Provider profile, category, rates, verification and availability state |
| `conversations/{id}` | Chat metadata, participants, last message and read state |
| `conversations/{id}/messages` | Individual chat messages ordered by timestamp |

**Planned**

| Collection | Purpose |
| --- | --- |
| `bookings/{id}` | Service request, schedule, status, pricing and participants |
| `reviews/{id}` | Rating, comment, reviewer and provider references |
| `notifications/{id}` | Server-generated user notifications for FCM delivery |
| `transactions/{id}` | Payment, payout and refund records |

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
│   │   ├── chat_service.dart       # Direct messaging, reactive streams & auto-replies
│   │   ├── favorites_service.dart  # Favorite provider persistence & reactive state
│   │   └── notification_service.dart # Reactive notifications, unread state & alerts
│   ├── splash/                     # Startup splash screen
│   ├── welcome/                    # Welcome & sign-in screen
│   └── widgets/                    # Reusable widgets
│       ├── clippers/               # Geometric and wave shape clippers
│       ├── address_picker_sheet.dart # Bottom sheet for location selection
│       ├── auth_gate.dart          # Role-based route gatekeeper
│       ├── cancel_booking_dialog.dart # Booking cancellation modal
│       ├── provider_bottom_nav.dart # Provider navigation bar
│       └── provider_filter_sheet.dart # Filter & sort bottom sheet
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
   *Make sure you enable **Authentication** (Email, Google, Apple) and **Cloud Firestore** in your Firebase Console.*

4. **Run native splash generator (optional, if assets were modified):**
   ```bash
   dart run flutter_native_splash:create
   ```

5. **Run the application:**
   ```bash
   flutter run
   ```

> **Offline/demo mode:** If Firebase is not configured, the chat service automatically falls back to an in-memory demo dataset so the app and tests still run.

---

## 🧪 Testing & Code Quality

- **Run widget and unit tests:**
  ```bash
  flutter test
  ```

  The current suite covers **22 passing tests**:
  - Model serialization (`User`, `Provider`, `Booking`, `Message`, `Conversation`, `SavedAddress`, `ProviderFilter`, `AppNotification`)
  - Favorites and saved provider persistence
  - Advanced provider filtering and sorting
  - Address presets and GPS detection
  - Booking cancellation dialog and wave clipper widgets
  - Chat service messaging, unread counts, and `ChatPage` rendering
  - Notification service lifecycle and `NotificationCenterPage` rendering

- **Run static code analysis:**
  ```bash
  flutter analyze
  ```

  The project currently reports **no analyzer issues** (0 errors, 0 warnings, 0 infos).

- **Format Dart code:**
  ```bash
  dart format .
  ```

---

## ⚠️ Known Limitations

- Provider listings, bookings, earnings, and admin metrics are demo data, not Firestore-backed.
- Payments are not processed; checkout only records a selected method.
- GPS detection is simulated rather than using the device location.
- Notifications are local-only; there is no push delivery.
- Chat attachments are previewed locally but not uploaded to cloud storage.
- Navigation uses hardcoded provider images from the web.
- No Firestore security rules or CI pipeline yet.

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
