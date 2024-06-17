import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_application/client/modal/client_modal_order.dart';
import 'package:flutter_application/company/modal/ModalInfo/info_order_modal.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_application/router/router.dart';
import 'package:flutter_application/service/setup.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    // debugPrint('Initializing Notification Service');
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint('Notification clicked');
        if (response.payload != null) {
          handleNotificationClick(response.payload!);
        }
      },
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'smart_appart',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: json.encode(payload),
    );
  }

  Future<String?> getUserRole(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userDoc.exists && userDoc['role'] != null) {
      return userDoc['role'];
    } else {
      return null;
    }
  }

  void handleNotificationClick(String payload) async {
    debugPrint('Handling notification click with payload: $payload');
    final appRouter = getIt<AppRouter>();
    debugPrint('AppRouter: $appRouter');

    final data = json.decode(payload) as Map<String, dynamic>;
    print(data);

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint('No user currently signed in');
      return;
    }

    final String? role = await getUserRole(user.uid);

    if (role == null) {
      debugPrint('User role not found');
      appRouter.push(DevelopmentRoute());
      return;
    }

    if (data['screen'] == 'news') {
      final int id = int.parse(data['id'].toString());
      switch (role) {
        case 'client':
          appRouter.push(
            NewsRoute(id: id, type: 'client'),
          );
          break;
        case 'Company':
          appRouter.push(
            NewsRoute(id: id, type: ''),
          );
          break;
        case 'Employee':
          appRouter.push(
            NewsRoute(id: id, type: ''),
          );
          break;
        default:
          appRouter.push(DevelopmentRoute());
      }
    }
    if (data['screen'] == 'order') {
      BuildContext context = appRouter.navigatorKey.currentContext!;
      final int apartmentId = int.parse(data['apartment_id'].toString());
      final int orderId = int.parse(data['order_id'].toString());
      print(data);
      switch (role) {
        case 'client':
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return ClientOrderModal(appartmentId: apartmentId, id: orderId);
            },
          );
          break;
        case 'Company':
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return InfoOrderModal(appartmentId: apartmentId, id: orderId);
            },
          );
          break;
        case 'Employee':
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return InfoOrderModal(appartmentId: apartmentId, id: orderId);
            },
          );
          break;
        default:
          appRouter.push(DevelopmentRoute());
      }
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message: ${message.messageId}');
}

void saveNotificationToFirestore(RemoteMessage message, User user) async {
  String? id = message.data.containsKey('id')
      ? message.data['id']
      : message.data.containsKey('order_id')
          ? message.data['order_id']
          : null;

  String? apartmentId = message.data.containsKey('apartment_id')
      ? message.data['apartment_id']
      : null;
  String? screen =
      message.data.containsKey('screen') ? message.data['screen'] : null;

  String? userRole = await NotificationService().getUserRole(user.uid);

  FirebaseFirestore.instance.collection('notifications').add({
    'user_id': user.uid,
    'title': message.notification?.title ?? 'No title',
    'body': message.notification?.body ?? 'No body',
    'is_view': {
      'client': false,
      'company': false,
      'employee': false,
    },
    'id': id,
    'apartment_id': apartmentId,
    'screen': screen,
    'role': userRole,
    'timestamp': FieldValue.serverTimestamp(),
  }).then((value) {
    print('Notification saved to Firestore');
  }).catchError((error) {
    print('Failed to save notification: $error');
  });
}

void setupFirebaseMessaging(BuildContext context) {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      saveNotificationToFirestore(event, user);
      NotificationService().showNotification(
        id: event.hashCode,
        title: event.notification?.title ?? 'Title',
        body: event.notification?.body ?? 'Body',
        payload:
            event.data.isNotEmpty ? event.data : {'screen': 'default_screen'},
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
    debugPrint('Message opened from background');
    handleMessage(event);
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      debugPrint('Initial message received');
      handleMessage(message);
    }
  });
}

void handleMessage(RemoteMessage message) {
  final data = message.data;
  debugPrint('Handling message data: $data');
  if (data['click_action'] == 'FLUTTER_NOTIFICATION_CLICK') {
    NotificationService().handleNotificationClick(json.encode(data));
  }
}
