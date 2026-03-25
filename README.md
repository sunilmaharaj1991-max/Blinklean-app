# BlinKlean - India's 1st AI Powered QuickClean Platform

A complete Flutter mobile app for home services including:
- **Home Cleaning** (1BHK, 2BHK, 3BHK, Kitchen, Bathroom, Sofa, Carpet, Office)
- **Vehicle Care** (Car, Bike, Auto Rickshaw, Bicycle - waterless cleaning)
- **Laundry Services** (Wash & Fold, Wash & Iron, Steam Iron, Dry Cleaning)
- **Scrap & Recycling** (Paper, Plastic, Metal, E-Waste, Cardboard, Glass)

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | Flutter 3.x |
| Auth | Firebase Auth (Gmail + Phone OTP) |
| Database | MongoDB Atlas |
| Backend | Node.js + Express |
| Payments | Razorpay |

## Project Structure

```
blinklean/
├── lib/                      # Flutter app
│   ├── main.dart             # Entry point
│   ├── core/                 # Theme, config
│   ├── models/               # Data models
│   ├── screens/              # UI screens
│   └── services/             # API, Auth services
├── provider/                 # Provider app
├── admin/                    # Admin panel
└── backend/                 # Node.js backend
    ├── models/              # MongoDB schemas
    ├── routes/              # API routes
    └── controllers/         # Business logic
```

## Quick Setup

### 1. Backend
```bash
cd backend
npm install
cp .env.example .env
# Edit .env with MongoDB URI and Firebase credentials
npm start
```

### 2. Firebase
1. Create project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android app with package: `com.blinklean.app`
3. Download `google-services.json` to `android/app/`
4. Enable Email/Password, Google, and Phone auth
5. **Important:** Add SHA-1 fingerprint for Google Sign-In

### 3. Flutter App
```bash
flutter pub get
flutter run
```

## Google Sign-In Fix

If you get "Cannot read image.png" error:

1. Get SHA-1:
```bash
keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
```

2. Add to Firebase Console → Project Settings → Your apps → SHA fingerprint

3. Download updated google-services.json

## Features

- [x] Firebase Auth (Gmail + Phone OTP)
- [x] MongoDB backend API
- [x] Provider app with unified bookings (services + scrap)
- [x] Admin dashboard
- [x] Premium UI design
- [x] WhatsApp scrap booking

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/auth/sync | Sync user |
| GET | /api/services | Get services |
| POST | /api/bookings | Create booking |
| GET | /api/providers/bookings | Provider's bookings |

## License
Private - All rights reserved
