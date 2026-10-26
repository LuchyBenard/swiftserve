# ⚡ SwiftServe

An on-demand service booking and marketplace mobile application built with **Flutter** and **Firebase**. **SwiftServe** bridges the gap between clients and skilled freelance professionals (barbers, phone/tech repair specialists, stylists, plumbers, electricians, mechanics, and more), offering a streamlined, real-time booking and job tracking experience.

---

## 📱 Features Overview

### 👤 Client Experience
- **Interactive Onboarding & Welcome:** Engaging onboarding flow featuring smooth page indicators and liquid swipe transitions.
- **Service Discovery & Search:** Browse diverse service categories (e.g., Tech Repair, Barbering, Styling, Plumbing) with real-time filters and search.
- **Provider Profiles & Portfolios:** Comprehensive provider profiles displaying ratings, review counts, distances, hourly/base pricing, bios, and service offerings.
- **Multi-Step Booking Flow:**
  - **Step 1 — Details:** Select services and describe requirements.
  - **Step 2 — Schedule:** Choose booking date and convenient time slots.
  - **Step 3 — Review & Checkout:** Verify request details, view cost breakdowns, and finalize booking.
- **Live Job Tracking:** Monitor ongoing service requests with status stages (`In Progress`, `Confirmed`, `Completed`, `Canceled`).
- **In-App Messaging:** Real-time 1-on-1 chat between clients and providers for direct communication.
- **Ratings & Reviews:** Leave 5-star ratings and written feedback once a job is complete.
- **Profile & History:** Manage personal details and track historical bookings.

### 🛠️ Service Provider Portal
- **Provider Registration & Verification:** Onboarding workflow for professionals to submit their category, experience, base rates, bio, and verification documents.
- **Dedicated Dashboard:** Bottom navigation optimized for providers.
- **Active Jobs Management:** Accept, manage, and update the status of incoming client requests.
- **Schedule & Availability:** Configure work schedules and toggle real-time availability.
- **Earnings & Analytics:** Track revenue, completed jobs, and detailed transaction histories.

### 🛡️ Admin & Moderation Suite
- **Admin Dashboard:** High-level overview of platform metrics, active jobs, and users.
- **Provider Moderation:** Review incoming worker registrations and approve or reject provider profiles.
- **User Management:** Manage client and provider accounts across the platform.

### 🔐 Authentication & Security
- **Role-Based Routing (`AuthGate`):** Dynamically steers users to Client or Provider workspaces based on their Firestore role profile.
- **Multiple Sign-In Options:**
  - Email & Password authentication.
  - Google Sign-In integration.
  - Apple Sign-In support.
- **Account Recovery:** Forgot password and OTP verification workflows.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** [Flutter](https://flutter.dev) (SDK `^3.10.7`) / [Dart](https://dart.dev)
- **Backend & Cloud Services:**
  - **Firebase Authentication:** Secure user identity management and social logins.
  - **Cloud Firestore:** Real-time NoSQL cloud database for users, providers, bookings, messages, and reviews.
- **UI & UX:**
  - Modern dark mode aesthetic with vibrant neon green accent (`#25F46A`) and purple splash branding (`#4A148C`).
  - [Google Fonts](https://pub.dev/packages/google_fonts) for typography.
  - [Liquid Swipe](https://pub.dev/packages/liquid_swipe) & [Smooth Page Indicator](https://pub.dev/packages/smooth_page_indicator) for interactive onboarding.
  - Custom geometric clippers and glassmorphic overlay effects.
  - [Flutter Native Splash](https://pub.dev/packages/flutter_native_splash) for splash screen generation.
- **Native & Utility Packages:**
  - [Image Picker](https://pub.dev/packages/image_picker): Profile picture and verification uploads.
  - [URL Launcher](https://pub.dev/packages/url_launcher): Dialing, emailing, and opening external URLs.
  - [Shared Preferences](https://pub.dev/packages/shared_preferences): Local persistence for onboarding completion state.

---

## 📂 Project Structure

```text
swiftserve/
├── android/                   # Native Android configuration
├── ios/                       # Native iOS configuration
├── assets/                    # Static assets & images
│   └── images/                # App icons, avatars & onboarding artwork
├── lib/
│   ├── firebase_options.dart  # Firebase initialization configuration
│   ├── main.dart              # Application entrypoint & global theme
│   ├── models/                # Data transfer objects & entity models
│   │   ├── booking.dart       # Booking state and metadata
│   │   ├── conversation.dart  # Chat inbox conversations
│   │   ├── message.dart       # Individual chat messages
│   │   ├── provider.dart      # Service provider profile model
│   │   └── user.dart          # User account model
│   ├── onboarding/            # Onboarding walkthrough screens
│   ├── pages/                 # UI screens and navigation flows
│   │   ├── admin/             # Admin management & moderation screens
│   │   ├── auth/              # Sign-in, sign-up, OTP & worker registration
│   │   ├── provider/          # Provider jobs, earnings & availability
│   │   ├── rating/            # Review & rating submission
│   │   ├── request/           # Multi-step service request flow
│   │   ├── tracking/          # Real-time job status tracking
│   │   ├── booking_page.dart  # Bookings list page
│   │   ├── bottomnav.dart     # Client bottom navigation shell
│   │   ├── chat_page.dart     # Direct message chat room
│   │   ├── chat_inbox_page.dart# Recent conversations inbox
│   │   ├── homepage.dart      # Main client dashboard & categories
│   │   └── profile_page.dart  # User profile management
│   ├── services/              # External services & business logic
│   │   └── auth_service.dart  # Firebase Auth & Firestore user sync
│   ├── splash/                # Startup splash screen
│   ├── welcome/               # Post-onboarding welcome screen
│   └── widgets/               # Reusable widgets (AuthGate, clippers, navbars)
├── test/                      # Unit and widget tests
├── pubspec.yaml               # Project dependencies and asset definitions
└── README.md                  # Project documentation
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed on your machine:
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.10.7 or higher)
- [Dart SDK](https://dart.dev/get-dart)
- An active [Firebase Project](https://console.firebase.google.com/)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/) for Firebase setup
- Xcode (for iOS/macOS) and/or Android Studio (for Android)

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/swiftserve.git
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

---

## 🧪 Testing & Code Quality

- **Run widget and unit tests:**
  ```bash
  flutter test
  ```

- **Run static code analysis:**
  ```bash
  flutter analyze
  ```

- **Format Dart code:**
  ```bash
  dart format .
  ```

---

## 👥 User Roles & Flow

```
                  ┌──────────────────────┐
                  │    Splash Screen     │
                  └──────────┬───────────┘
                             │
                      [AuthGate Check]
                       /            \
           (Logged Out)              (Logged In)
               /                            \
   ┌───────────────────────┐          ┌──────────────┐
   │ Onboarding / Welcome  │          │ Check Role   │
   └──────────┬────────────┘          └──────┬───────┘
              │                              │
   ┌───────────────────────┐         ┌───────┴───────┐
   │  Sign In / Register   │         │               │
   │  (Client or Provider) │     [Client]       [Provider]
   └───────────────────────┘         │               │
                            ┌────────┴──────┐ ┌──────┴──────────────┐
                            │ Client Home   │ │ Provider Dashboard  │
                            │ • Browse      │ │ • Active Jobs       │
                            │ • Book        │ │ • Availability      │
                            │ • Track       │ │ • Earnings          │
                            │ • Chat        │ │ • Schedule          │
                            └───────────────┘ └─────────────────────┘
```

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
