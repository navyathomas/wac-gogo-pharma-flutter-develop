import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:gogo_pharma/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:gogo_pharma/widgets/reusable_widgets.dart';

import '../models/notification_model.dart';

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

class FirebaseMessagingServices {
  static PushNotification? _notificationInfo;

  static fetchFirebaseToken(BuildContext context) async {
    late final FirebaseMessaging firebaseMessaging;
    await Firebase.initializeApp();
    firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getToken().then((token) async {
      log("FIREBASE TOKEN:" + token.toString());
      context.read<AuthProvider>().setFirebaseToken(token!);
    });
  }

  static void registerNotification() async {
    await Firebase.initializeApp();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((token) {
      log(token.toString());
    });
    messaging.subscribeToTopic("all");
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
    }

    messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        _notificationInfo = notification;

        if (_notificationInfo != null) {
          ReusableWidgets.showInAppMsg(_notificationInfo!);
        }
      });

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    } else {
      print('User declined or has not accepted permission');
    }
  }

  static void handleOnBackground() {
    // For handling notification when the app is in background
    // but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
      );
      _notificationInfo = notification;
    });
  }

  // For handling notification when the app is in terminated state
  static checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      _notificationInfo = notification;
    }
  }
}
