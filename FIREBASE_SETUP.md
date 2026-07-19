# Firebase Notification Setup Guide for BidFounder Market

## ✅ Already Completed

1. ✅ Firebase dependencies added to `pubspec.yaml`
2. ✅ Firebase notification service created (`lib/services/notifications/firebase_notification_service.dart`)
3. ✅ Notification store created (`lib/services/notifications/notification_store.dart`)
4. ✅ Firebase options file created (`lib/firebase_options.dart`)
5. ✅ Android build files updated with Google Services plugin
6. ✅ Main.dart updated with Firebase initialization
7. ✅ Auth store updated to initialize notifications after login

## 📋 TODO: Steps to Complete Firebase Integration

### Step 1: Install Dependencies
```bash
flutter pub get
```

### Step 2: Update Firebase Options
- Open `lib/firebase_options.dart`
- Update all Firebase project credentials with your **BidFounder Market** Firebase project:
  - `projectId`: Change from `'ehikmat-hakeem-app'` to your project ID
  - `apiKey`: Update with your Firebase API keys
  - `appId`: Update with your app IDs
  - `messagingSenderId`: Update with your sender ID
  - `storageBucket`: Update with your storage bucket
  - `iosBundleId`: Update to match your iOS bundle ID

### Step 3: Create/Update Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project named **BidFounder Market** (or use existing)
3. Enable Cloud Messaging in Firebase Console

### Step 4: Add Android Configuration
1. In Firebase Console → Project Settings → Add Android App
2. Package name: `com.example.bidfounder_market` (check `android/app/build.gradle.kts` line 24)
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`
5. ✅ Google Services plugin already added to build files

### Step 5: Add iOS Configuration
1. In Firebase Console → Project Settings → Add iOS App
2. Bundle ID: Check your `ios/Runner/Info.plist` for Bundle Identifier
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`
5. Add file to Xcode project (drag and drop in Xcode)

### Step 6: Update Backend API Endpoints
- Open `lib/constants/api_endpoints.dart`
- Update these endpoints when your backend is ready:
  ```dart
  static const String saveFCMToken = '/users/fcm-token/'; // Your actual endpoint
  static const String notificationPreferences = '/users/notification-preferences/'; // Your actual endpoint
  ```

### Step 7: Implement Token Saving to Backend
- Open `lib/services/notifications/firebase_notification_service.dart`
- Complete the `saveTokenToBackend()` method (line ~230)
- Uncomment and update the API call:
  ```dart
  await ApiService.post(
    ApiEndpoints.saveFCMToken,
    body: {'fcm_token': token},
    includeAuth: true,
  );
  ```

### Step 8: Configure Notification Navigation
- Open `lib/services/notifications/firebase_notification_service.dart`
- In `_onNotificationTapped()` method (line ~195), add navigation logic:
  ```dart
  // Example:
  if (data['type'] == 'chat') {
    Navigator.pushNamed(context, AppRouter.chatDetail, 
      arguments: {'chatId': data['chatId']});
  }
  ```

### Step 9: (Optional) Add Service Account for Sending Notifications
- If you want to send notifications from the app:
  1. Firebase Console → Project Settings → Service Accounts
  2. Generate new private key → Download `service-account.json`
  3. Place in `assets/service-account.json`
  4. Uncomment in `pubspec.yaml`:
     ```yaml
     assets:
       - assets/service-account.json
     ```
  5. Uncomment code in `sendPushNotificationV1()` method

### Step 10: Test Notifications
1. Run `flutter pub get` (if not done)
2. Run the app
3. Login to get FCM token (check console logs)
4. Use Firebase Console → Cloud Messaging → Send test message
5. Test foreground, background, and terminated app states

## 📁 File Structure

```
lib/
├── firebase_options.dart                    ← Firebase configuration (UPDATE THIS)
├── services/
│   └── notifications/
│       ├── firebase_notification_service.dart  ← Main notification service
│       └── notification_store.dart            ← Notification state management
├── main.dart                                 ← Firebase initialization
└── store/
    └── auth_store.dart                       ← Auto-initializes notifications after login
```

## 🔧 Key Integration Points

1. **`lib/firebase_options.dart`**: Update with your Firebase project credentials
2. **`lib/services/notifications/firebase_notification_service.dart`**:
   - Line ~230: Implement `saveTokenToBackend()`
   - Line ~195: Add navigation in `_onNotificationTapped()`
3. **`lib/constants/api_endpoints.dart`**: Update notification endpoints
4. **`android/app/google-services.json`**: Add this file from Firebase Console
5. **`ios/Runner/GoogleService-Info.plist`**: Add this file from Firebase Console

## 📝 What Happens Automatically

- ✅ FCM token is retrieved after login
- ✅ Token is saved to backend (when you implement `saveTokenToBackend()`)
- ✅ Foreground notifications are displayed automatically
- ✅ Background notifications are handled automatically
- ✅ Notification taps are captured (you add navigation logic)

## 🚀 Quick Start Checklist

- [ ] Run `flutter pub get`
- [ ] Update `firebase_options.dart` with your Firebase credentials
- [ ] Add `google-services.json` to `android/app/`
- [ ] Add `GoogleService-Info.plist` to `ios/Runner/`
- [ ] Update API endpoints in `api_endpoints.dart`
- [ ] Implement `saveTokenToBackend()` method
- [ ] Add navigation logic in `_onNotificationTapped()`
- [ ] Test notifications from Firebase Console

## 📞 Need Help?

All code is integrated and ready. Just update the Firebase credentials and configuration files!

