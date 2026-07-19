# BidFounder Market

Mobile marketplace for listing and buying products with **fixed price**, **auction bidding**, and **Buy Now**. Buyers and sellers share one Flutter app backed by a Django REST API.

## Project structure

```
bidfounder-market/
├── bidfounder_market_frontend/   # Flutter mobile app
└── bidfounder_market_backend/
    └── bid-founder/              # Django + DRF API
```

## Tech stack

| Layer | Stack |
|-------|--------|
| **Frontend** | Flutter 3.9+, Provider, HTTP, Firebase Messaging |
| **Backend** | Django 5.2, Django REST Framework, SimpleJWT |
| **Database** | MySQL |
| **Realtime** | Django Channels + Redis (chat stubs) |

## Features

- **Auth** — Register (email + phone), OTP verify, login, forgot/reset password
- **Browse** — Categories, subcategories, product search and detail
- **Sell** — Create listings with images, condition, and shipping
- **Bidding** — Place bids, accept bids, end auctions, Buy Now
- **Orders** — Create and track orders
- **Reviews** — Product reviews with moderation APIs
- **Settings** — Profile, address book, account settings

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.9.2)
- Python 3.10+
- MySQL
- Redis (optional; needed for Channels)

## Backend setup

```powershell
cd bidfounder_market_backend\bid-founder

python -m venv venv
.\venv\Scripts\Activate.ps1

# Install dependencies (no requirements.txt yet — install from the existing venv or manually):
# pip install Django djangorestframework djangorestframework-simplejwt
# pip install django-cors-headers channels channels-redis redis
# pip install mysqlclient PyMySQL python-dotenv Pillow stripe
```

Create a `.env` file in `bid-founder/`:

```env
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

Then:

```powershell
python manage.py migrate
python manage.py createsuperuser   # optional
python manage.py runserver 0.0.0.0:8000
```

- API base: `http://localhost:8000`
- Admin: `http://localhost:8000/admin/`

### Main API routes

| Prefix | App |
|--------|-----|
| `/users/` | Auth, profile |
| `/products/` | Categories, listings, images |
| `/bidding/` | Bids, buy-now, accept/end auction |
| `/orders/` | Orders |
| `/reviews/` | Reviews |

## Frontend setup

```powershell
cd bidfounder_market_frontend
flutter pub get
flutter run
```

Update the API base URL in `lib/constants/api_endpoints.dart` to your machine’s IP (device/emulator must reach the Django server):

```dart
static const String baseUrl = 'http://YOUR_IP:8000';
```

### Firebase (optional)

Push notifications are prepared but Firebase init is currently commented out in `main.dart`. See [FIREBASE_SETUP.md](bidfounder_market_frontend/FIREBASE_SETUP.md).

## Docs

- [Firebase setup](bidfounder_market_frontend/FIREBASE_SETUP.md)
- [Notifications service](bidfounder_market_frontend/lib/services/notifications/README.md)

## License

Private project — all rights reserved.
