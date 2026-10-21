# BidFounder Market

A modern, cross-platform marketplace application built with **Flutter** and **Django REST Framework**, designed to connect buyers and sellers through product listings, fixed-price purchases, auction bidding, and Buy Now functionality.

BidFounder Market brings marketplace experiences into one application, with a Flutter frontend and a Django-powered backend.

## Overview

The project includes a Flutter application targeting Android, iOS, web, Windows, macOS, and Linux, alongside a Django REST API for marketplace operations.

The platform is designed to support product discovery, selling, auctions, order management, reviews, user profiles, and notifications.

## Key Features

### Authentication & User Accounts
- User registration and login
- Email and phone-based account workflows
- OTP verification
- Forgot-password and password-reset flows
- Profile and account settings

### Product Discovery
- Browse product categories and subcategories
- Search and view product details
- Display product images, condition, and shipping information

### Selling & Listings
- Create product listings
- Upload product images
- Specify product condition and shipping details
- Manage marketplace listings

### Auctions & Purchasing
- Place bids on auction listings
- Accept bids and end auctions
- Support fixed-price purchasing
- Buy Now functionality

### Orders & Reviews
- Create and track orders
- Submit product reviews
- Support review moderation through backend APIs

### Notifications
- Firebase Cloud Messaging integration groundwork
- Notification service and local notification state management
- Planned backend token synchronization and notification-tap navigation

> **Implementation status:** Features may have different completion levels. Verify the relevant frontend screens, API endpoints, payment workflows, and notification behavior before treating every feature as production-ready.

## Technology Stack

| Layer | Technologies |
|---|---|
| Frontend | Flutter, Dart |
| State Management | Provider |
| API Communication | HTTP |
| Backend | Python, Django, Django REST Framework |
| Authentication | SimpleJWT |
| Database | MySQL |
| Real-Time Infrastructure | Django Channels, Redis |
| Push Notifications | Firebase Cloud Messaging |
| Payment Integration | Stripe integration groundwork |

## Project Structure

```text
bidfounder_market_frontend/
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
├── assets/
│   └── images/
├── lib/
├── test/
├── FIREBASE_SETUP.md
├── firebase.json
├── pubspec.yaml
└── README.md
```

The Django backend is maintained separately in the associated `bidfounder_market_backend` project.

## Prerequisites

Install the following tools before running the application:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) compatible with the project's Dart constraints
- Android Studio or Xcode for mobile development
- Python 3.10 or a version supported by the backend
- MySQL
- Redis if using Django Channels functionality
- Firebase project credentials for push notifications

## Getting Started

### 1. Clone the Repository

The repository is private, so you must have GitHub access to clone it.

```bash
git clone https://github.com/usmana0820/bidfounder_market_frontend.git
cd bidfounder_market_frontend
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Configure the Backend API

Open `lib/constants/api_endpoints.dart` and configure the base URL to point to your Django backend.

For example:

```dart
static const String baseUrl = 'http://YOUR_IP:8000';
```

Replace `YOUR_IP` with the development machine's IP address when using a physical device. Android emulators may use a special host address to reach the development machine.

Ensure the backend is running and accessible before testing API-dependent screens.

### 4. Run the Application

```bash
flutter run
```

To target a specific platform, select a configured device or use the appropriate Flutter device options.

## Backend Setup

The Django backend is maintained separately. Navigate to its `bid-founder` directory and create a virtual environment.

**Windows PowerShell:**

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

Install the dependencies listed by the backend project. If a `requirements.txt` file is available, use:

```bash
pip install -r requirements.txt
```

Configure the backend's environment variables in a `.env` file:

```dotenv
SECRET_KEY=your-secret-key
DEBUG=True
DB_NAME=bidfounder
DB_USER=root
DB_PASS=your-password
DB_HOST=127.0.0.1
DB_PORT=3306
STRIPE_SECRET_KEY=
STRIPE_WEBHOOK_SECRET=
```

Use actual credentials for your local environment. Keep secrets out of version control, and disable debug mode in production.

Run database migrations and start the server from the directory containing `manage.py`:

```bash
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

Optional: create an administrator account with `python manage.py createsuperuser`.

- API base URL: `http://localhost:8000`
- Django admin: `http://localhost:8000/admin/`

## Main API Areas

| Endpoint Prefix | Purpose |
|---|---|
| `/users/` | Authentication and user profiles |
| `/products/` | Categories, listings, and product images |
| `/bidding/` | Bids and auction operations |
| `/orders/` | Order management |
| `/reviews/` | Product reviews |

Refer to the backend implementation for the actual available endpoints and request formats.

## Firebase Notifications

The repository includes `FIREBASE_SETUP.md` with configuration guidance.

Before enabling push notifications:

1. Configure the correct Firebase project and application identifiers.
2. Add the required Android and iOS Firebase configuration files.
3. Verify Firebase initialization in the Flutter application.
4. Implement and test FCM token registration with the backend.
5. Configure notification-tap navigation.
6. Test notifications in foreground, background, and terminated states.

See [Firebase Setup Guide](FIREBASE_SETUP.md).

**Security note:** Never include Firebase service-account private keys or other server-side credentials in the Flutter application or a public repository. Send push notifications from a trusted backend environment.

## Testing

Run the available Flutter tests with:

```bash
flutter test
```

Before release, test authentication, listing creation, image uploads, bidding rules, Buy Now, order tracking, API error handling, and notification delivery.

## Future Improvements

Potential enhancements include:

- Completing end-to-end Firebase notification delivery
- Real-time chat and messaging
- Improved auction status synchronization
- Payment workflow verification
- Automated frontend and backend integration tests
- Enhanced search, filtering, and seller management

## License

This is a private project. All rights reserved. Do not redistribute or reuse its source code without authorization.

## Author

**Usmana Zulfiqar**

Full-Stack Software Engineer

*Flutter · Dart · Django REST Framework · MySQL · Firebase*

- GitHub: [@usmana0820](https://github.com/usmana0820)
- Email: usmanazulfiqar20@gmail.com

---

*BidFounder Market — Discover products, place bids, and buy with confidence.*
