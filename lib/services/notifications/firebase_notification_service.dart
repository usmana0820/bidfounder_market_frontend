// import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart';

// /// Firebase Notification Service
// /// 
// /// This service handles:
// /// - Firebase Cloud Messaging (FCM) initialization
// /// - Token management (getting and saving FCM token)
// /// - Handling foreground, background, and terminated app notifications
// /// - Local notifications display
// /// - Sending push notifications to other devices
// /// 
// /// Integrated from existing project code
// class FirebaseNotificationService {
//   static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _localNotifications = 
//       FlutterLocalNotificationsPlugin();

//   /// Initialize Firebase notifications
//   /// 
//   /// Call this in main.dart after Firebase.initializeApp()
//   /// 
//   /// This method:
//   /// - Requests notification permissions
//   /// - Initializes local notifications
//   /// - Gets and displays FCM token
//   /// - Sets up message handlers for foreground, background, and terminated states
//   static Future<void> initialize() async {
//     try {
//       // Request notification permissions (for iOS)
//       NotificationSettings settings = await _firebaseMessaging.requestPermission(
//         alert: true,
//         badge: true,
//         sound: true,
//         provisional: false,
//       );

//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         debugPrint('✅ User granted notification permission');
//       } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
//         debugPrint('⚠️ User granted provisional notification permission');
//       } else {
//         debugPrint('❌ User declined or has not accepted notification permission');
//       }

//       // Initialize local notifications
//       await _initializeLocalNotifications();

//       // Get FCM token
//       String? token = await getFCMToken();
//       if (token != null) {
//         debugPrint('🔹 Device FCM Token: $token');
//         // TODO: Save token to your backend API
//         // await saveTokenToBackend(token);
//       }

//       // Configure message handlers
//       _configureMessageHandlers();

//     } catch (e) {
//       debugPrint('❌ Error initializing Firebase notifications: $e');
//     }
//   }

//   /// Initialize local notifications plugin
//   /// 
//   /// Sets up local notifications for Android and iOS
//   /// Creates notification channel for Android
//   static Future<void> _initializeLocalNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );

//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await _localNotifications.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onNotificationTapped,
//     );

//     // Create notification channel for Android
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'bidfounder_market_notifications', // Channel ID
//       'BidFounder Market Notifications', // Channel name
//       description: 'Notifications for BidFounder Market app',
//       importance: Importance.high,
//       playSound: true,
//     );

//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   /// Configure Firebase message handlers
//   /// 
//   /// Sets up handlers for:
//   /// - Foreground messages (app is open)
//   /// - Background messages (app is in background)
//   /// - Terminated app messages (app was closed)
//   static void _configureMessageHandlers() {
//     // Handle foreground messages - show local notification
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       debugPrint('📩 Foreground message: ${message.notification?.title}');
//       debugPrint('📩 Body: ${message.notification?.body}');
      
//       // Show local notification for all FCM messages
//       await _showLocalNotification(
//         title: message.notification?.title ?? 'BidFounder Market',
//         body: message.notification?.body ?? '',
//         data: message.data,
//       );
      
//       // TODO: Handle notification data based on your requirements
//       // Example: Navigate to specific screen, update UI, etc.
//     });

//     // Handle background messages (when app is in background)
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       debugPrint('📩 Background message opened: ${message.messageId}');
//       debugPrint('📩 Data: ${message.data}');
//       // TODO: Navigate to specific screen based on notification data
//       // Example: if (message.data['type'] == 'chat') { navigate to chat screen }
//     });

//     // Handle notification when app is terminated
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//       if (message != null) {
//         debugPrint('📩 Terminated app message: ${message.messageId}');
//         debugPrint('📩 Data: ${message.data}');
//         // TODO: Navigate to specific screen based on notification data
//       }
//     });
//   }

//   /// Show local notification
//   /// 
//   /// Displays a local notification with the provided title, body, and data
//   static Future<void> _showLocalNotification({
//     required String title,
//     required String body,
//     Map<String, dynamic>? data,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'bidfounder_market_notifications', // Channel ID
//       'BidFounder Market Notifications', // Channel name
//       channelDescription: 'Notifications for BidFounder Market app',
//       importance: Importance.high,
//       priority: Priority.high,
//       showWhen: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );

//     await _localNotifications.show(
//       DateTime.now().millisecondsSinceEpoch % 100000,
//       title,
//       body,
//       details,
//       payload: data != null ? jsonEncode(data) : null,
//     );
//   }

//   /// Handle notification tap
//   /// 
//   /// Called when user taps on a notification
//   /// TODO: Add navigation logic based on notification payload
//   static void _onNotificationTapped(NotificationResponse response) {
//     debugPrint('🔔 Notification tapped: ${response.payload}');
    
//     if (response.payload != null) {
//       try {
//         final data = jsonDecode(response.payload!);
//         debugPrint('📦 Notification data: $data');
        
//         // TODO: Parse payload and navigate to appropriate screen
//         // Example:
//         // if (data['type'] == 'chat') {
//         //   Navigator.pushNamed(context, AppRouter.chatDetail, arguments: {'chatId': data['chatId']});
//         // } else if (data['type'] == 'order') {
//         //   Navigator.pushNamed(context, AppRouter.orderDetail, arguments: {'orderId': data['orderId']});
//         // }
//       } catch (e) {
//         debugPrint('❌ Error parsing notification payload: $e');
//       }
//     }
//   }

//   /// Get FCM token
//   /// 
//   /// Returns the FCM token for this device
//   /// This token should be saved to your backend when user logs in
//   static Future<String?> getFCMToken() async {
//     try {
//       return await _firebaseMessaging.getToken();
//     } catch (e) {
//       debugPrint('Error getting FCM token: $e');
//       return null;
//     }
//   }

//   /// Save FCM token to backend
//   /// 
//   /// Saves the FCM token to your backend API so you can send notifications to this device
//   /// 
//   /// TODO: Implement API call to save token to your backend
//   /// Example:
//   /// ```dart
//   /// await ApiService.post(
//   ///   ApiEndpoints.saveFCMToken,
//   ///   body: {'fcm_token': token},
//   ///   includeAuth: true,
//   /// );
//   /// ```
//   static Future<void> saveTokenToBackend(String token) async {
//     try {
//       // TODO: Implement token saving to your backend API
//       // Uncomment and update when your backend endpoint is ready:
//       /*
//       await ApiService.post(
//         ApiEndpoints.saveFCMToken,
//         body: {'fcm_token': token},
//         includeAuth: true,
//       );
//       */
//       debugPrint('💾 TODO: Save FCM token to backend: $token');
//     } catch (e) {
//       debugPrint('❌ Error saving FCM token to backend: $e');
//     }
//   }

//   /// Delete FCM token
//   /// 
//   /// Call this when user logs out
//   static Future<void> deleteToken() async {
//     try {
//       await _firebaseMessaging.deleteToken();
//       debugPrint('FCM token deleted');
//     } catch (e) {
//       debugPrint('Error deleting FCM token: $e');
//     }
//   }

//   /// Subscribe to topic
//   /// 
//   /// TODO: Use this to subscribe users to specific notification topics
//   static Future<void> subscribeToTopic(String topic) async {
//     try {
//       await _firebaseMessaging.subscribeToTopic(topic);
//       debugPrint('Subscribed to topic: $topic');
//     } catch (e) {
//       debugPrint('Error subscribing to topic: $e');
//     }
//   }

//   /// Unsubscribe from topic
//   static Future<void> unsubscribeFromTopic(String topic) async {
//     try {
//       await _firebaseMessaging.unsubscribeFromTopic(topic);
//       debugPrint('✅ Unsubscribed from topic: $topic');
//     } catch (e) {
//       debugPrint('❌ Error unsubscribing from topic: $e');
//     }
//   }

//   /// Send push notification to another device using its FCM token
//   /// 
//   /// This method sends a notification to a specific device using its FCM token.
//   /// 
//   /// Parameters:
//   /// - targetToken: FCM token of the target device
//   /// - title: Notification title
//   /// - body: Notification body
//   /// 
//   /// TODO: Implement this using your backend API instead of direct FCM calls
//   /// It's recommended to send notifications through your backend for security
//   static Future<void> sendPushNotification({
//     required String targetToken,
//     required String title,
//     required String body,
//   }) async {
//     try {
//       // TODO: Call your backend API to send notification
//       // Example:
//       // await ApiService.post(
//       //   ApiEndpoints.sendNotification,
//       //   body: {
//       //     'target_token': targetToken,
//       //     'title': title,
//       //     'body': body,
//       //   },
//       //   includeAuth: true,
//       // );
      
//       debugPrint('📤 TODO: Send notification to token: $targetToken');
//       debugPrint('   Title: $title');
//       debugPrint('   Body: $body');
      
//       // Alternative: Use FCM v1 API directly (requires service account)
//       // await sendPushNotificationV1(
//       //   projectId: 'bidfounder-market', // TODO: Update with your project ID
//       //   targetToken: targetToken,
//       //   title: title,
//       //   body: body,
//       // );
//     } catch (e) {
//       debugPrint('❌ Error sending push notification: $e');
//     }
//   }

//   /// Send push notification using FCM v1 API
//   /// 
//   /// This method uses Google Service Account to send notifications via FCM v1 API.
//   /// 
//   /// Requirements:
//   /// - service-account.json file in assets folder
//   /// - Firebase project ID
//   /// 
//   /// TODO: Add service-account.json to assets folder
//   /// Steps:
//   /// 1. Go to Firebase Console → Project Settings → Service Accounts
//   /// 2. Generate new private key
//   /// 3. Save as service-account.json
//   /// 4. Add to pubspec.yaml assets
//   /// 5. Uncomment the code below
//   static Future<void> sendPushNotificationV1({
//     required String projectId,
//     required String targetToken,
//     required String title,
//     required String body,
//   }) async {
//     try {
//       // TODO: Uncomment after adding service-account.json to assets
//       /*
//       final serviceAccount = ServiceAccountCredentials.fromJson(
//         json.decode(await rootBundle.loadString('assets/service-account.json')),
//       );

//       final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
//       final client = await clientViaServiceAccount(serviceAccount, scopes);

//       final url = Uri.parse(
//         'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
//       );

//       final message = {
//         "message": {
//           "token": targetToken,
//           "notification": {"title": title, "body": body},
//         }
//       };

//       final response = await client.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(message),
//       );

//       debugPrint('📩 Response ${response.statusCode}: ${response.body}');
//       client.close();
//       */
      
//       debugPrint('📤 TODO: Implement sendPushNotificationV1');
//       debugPrint('   Project ID: $projectId');
//       debugPrint('   Target Token: $targetToken');
//       debugPrint('   Title: $title');
//       debugPrint('   Body: $body');
//     } catch (e) {
//       debugPrint('❌ Error sending push notification via FCM v1: $e');
//     }
//   }
// }

// /// Background message handler
// /// 
// /// This function must be a top-level function to handle background messages
// /// It's called when app is in background and a notification is received.
// /// 
// /// Note: You cannot show UI here, but you can process data
// /// 
// /// TODO: Add your background message handling logic here
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('📩 Background message received: ${message.messageId}');
//   debugPrint('📩 Title: ${message.notification?.title}');
//   debugPrint('📩 Body: ${message.notification?.body}');
//   debugPrint('📩 Data: ${message.data}');
  
//   // TODO: Handle background notification data
//   // Example: Update local database, schedule tasks, etc.
// }

