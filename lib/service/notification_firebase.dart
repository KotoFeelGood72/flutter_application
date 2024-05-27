// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'notification_service.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   debugPrint('Handling a background message: ${message.messageId}');
// }

// void setupFirebaseMessaging(BuildContext context) {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;

//   messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );

//   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
//     debugPrint('Foreground message received');
//     NotificationService().showNotification(
//         id: event.hashCode,
//         title: event.notification?.title ?? 'Title',
//         body: event.notification?.body ?? 'Body',
//         payload: event.data);
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
//     debugPrint('Message opened from background');
//     handleMessage(event, context);
//   });

//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//     if (message != null) {
//       debugPrint('Initial message received');
//       handleMessage(message, context);
//     }
//   });
// }

// void handleMessage(RemoteMessage message, BuildContext context) {
//   final data = message.data;
//   debugPrint('Handling message data: $data');
//   // Добавьте логику обработки сообщения
//   if (data['click_action'] == 'FLUTTER_NOTIFICATION_CLICK') {
//     NotificationService().handleNotificationClick(data['screen']);
//   }
// }
