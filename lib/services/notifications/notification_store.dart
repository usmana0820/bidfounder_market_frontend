// import 'package:flutter/foundation.dart';
// import 'firebase_notification_service.dart';

// /// Notification Store - Manages notification state
// /// 
// /// This store handles:
// /// - FCM token management
// /// - Notification preferences
// /// - Notification history (optional)
// /// 
// /// TODO: Add your notification state management logic here
// class NotificationStore extends ChangeNotifier {
//   String? _fcmToken;
//   bool _notificationsEnabled = true;
//   bool _isLoading = false;

//   String? get fcmToken => _fcmToken;
//   bool get notificationsEnabled => _notificationsEnabled;
//   bool get isLoading => _isLoading;

//   /// Initialize notification store
//   /// 
//   /// Call this after user logs in to get and save FCM token
//   Future<void> initialize() async {
//     try {
//       _isLoading = true;
//       notifyListeners();

//       // Get FCM token
//       _fcmToken = await FirebaseNotificationService.getFCMToken();
      
//       if (_fcmToken != null) {
//         // Save token to backend
//         await FirebaseNotificationService.saveTokenToBackend(_fcmToken!);
//       }

//       _isLoading = false;
//       notifyListeners();
//     } catch (e) {
//       debugPrint('Error initializing notification store: $e');
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   /// Update notification preferences
//   /// 
//   /// TODO: Implement API call to save preferences to backend
//   Future<void> updateNotificationPreferences(bool enabled) async {
//     _notificationsEnabled = enabled;
//     notifyListeners();
    
//     // TODO: Save preferences to backend
//     // await ApiService.put(
//     //   ApiEndpoints.notificationPreferences,
//     //   body: {'notifications_enabled': enabled},
//     //   includeAuth: true,
//     // );
//   }

//   /// Clear notification data
//   /// 
//   /// Call this when user logs out
//   Future<void> clear() async {
//     await FirebaseNotificationService.deleteToken();
//     _fcmToken = null;
//     _notificationsEnabled = true;
//     notifyListeners();
//   }
// }

