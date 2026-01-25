import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    // Request permissions for all platforms
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Get the token
      String? token = await _fcm.getToken(
        vapidKey: kIsWeb ? "BGE2mo-tltDBixXoIPyfVdRTEK91ynVCDfgpVBAOUxznFhRBLYRoUnWpflvv_iDxQ3giu4YDIZ070Tk7-oR06H0" : null,
      );
      print("Token: $token");

      // Mobile-specific foreground setup
      if (!kIsWeb) {
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.max,
        );

        await _localPlugin
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          RemoteNotification? notification = message.notification;
          if (notification != null) {
            _localPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name),
              ),
            );
          }
        });
      }
    }
  }
}