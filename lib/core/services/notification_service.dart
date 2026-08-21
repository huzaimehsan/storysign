import 'package:firebase_messaging/firebase_messaging.dart';

import 'base_services.dart';



@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Background Message Received: ${message.messageId}");
}

class NotificationService extends BaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // 1. Initialize Notifications
  Future<void> initialize() async {

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');


      await getTokenAndRegister();
    } else {
      print('User declined notification permission');
    }


    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print("FCM Token Refreshed: $newToken");
      registerFCMTokenOnBackend(newToken);
    });


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground Message: ${message.notification?.title}');

    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.data}');

    });
  }


  Future<void> getTokenAndRegister() async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        print("FCM Token: $fcmToken");
        await registerFCMTokenOnBackend(fcmToken);
      }
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }


  Future<void> registerFCMTokenOnBackend(String token) async {

    final response = await basePostAPI(
      '/users/register-fcm-token',
      {'fcm_token': token},
      loading: false,
      showErrorToast: false,
    );

    if (response['success'] == true) {
      print("FCM Token successfully registered on backend.");
    } else {
      print("Failed to register FCM token: ${response['message']}");
    }
  }


  Future<void> removeFCMTokenOnBackend() async {
    try {
      String? fcmToken = await _firebaseMessaging.getToken();
      if (fcmToken != null) {
        final response = await basePostAPI(
          '/users/remove-fcm-token',
          {'fcm_token': fcmToken},
          loading: true,
        );

        if (response['success'] == true) {
          print("FCM Token successfully removed from backend.");

          await _firebaseMessaging.deleteToken();
        }
      }
    } catch (e) {
      print("Error removing FCM token: $e");
    }
  }
}