library push_notifiction_package;

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  pushNotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  getDiviceToken() {
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      var token = fcmToken;
    }).onError((err) {
      FirebaseMessaging.instance.getToken().then((value) {});
    });
  }
}

//-------------
/* 
  For notification click

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification.body!),
                    ],
                  ),
                ),
              );
            });
      }
    });  
*/

//------------------
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification!.title!,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          color: Colors.white,
          importance: Importance.max,
          channelShowBadge: true,
          enableVibration: true,
          playSound: true,
          icon: '@mipmap-hdpi/ic_launcher.png',
        ),
      ));
//---------------this code wa not here but can be used for pushing notification to lockscreen-----

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    AwesomeNotifications().initialize(
      '',
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Order Recieved Notification',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            channelShowBadge: true)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],

      //TODO
      debug: true,
    );

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        displayOnForeground: true,
        displayOnBackground: true,
        wakeUpScreen: true,
        id: Random().nextInt(20),
        channelKey: 'basic_channel',
        title: notification!.title!,
        body: notification.body,
        bigPicture: 'asset://assets/ic_launcher.png',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  });
}
