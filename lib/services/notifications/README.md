# Firebase Notification Service - BidFounder Market

## 📁 Files in this folder

### `firebase_notification_service.dart`
Main Firebase notification service that handles:
- FCM token management
- Foreground, background, and terminated app notifications
- Local notifications display
- Sending push notifications to other devices

**Key Methods:**
- `initialize()` - Initialize Firebase notifications (called in main.dart)
- `getFCMToken()` - Get device FCM token
- `saveTokenToBackend()` - Save token to your backend API (TODO: Implement)
- `sendPushNotification()` - Send notification to another device (TODO: Implement)
- `_onNotificationTapped()` - Handle notification tap (TODO: Add navigation)

### `notification_store.dart`
State management for notifications:
- FCM token storage
- Notification preferences
- Notification initialization after login

## 🔧 Integration Status

✅ **Completed:**
- Firebase dependencies added
- Service structure created
- Notification handlers configured
- Auto-initialization after login

⏳ **TODO:**
1. Update `lib/firebase_options.dart` with your Firebase project credentials
2. Add `google-services.json` to `android/app/`
3. Add `GoogleService-Info.plist` to `ios/Runner/`
4. Implement `saveTokenToBackend()` in `firebase_notification_service.dart`
5. Add navigation logic in `_onNotificationTapped()`
6. Update API endpoints in `lib/constants/api_endpoints.dart`

## 📝 Usage Example

```dart
// Get FCM token
String? token = await FirebaseNotificationService.getFCMToken();

// Save token to backend (after implementing)
await FirebaseNotificationService.saveTokenToBackend(token!);

// Send notification to another device (after implementing)
await FirebaseNotificationService.sendPushNotification(
  targetToken: 'user_fcm_token',
  title: 'New Message',
  body: 'You have a new message',
);
```

## 🎯 Next Steps

See `FIREBASE_SETUP.md` in project root for complete setup instructions.

