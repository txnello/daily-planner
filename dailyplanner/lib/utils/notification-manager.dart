// ignore_for_file: prefer_const_constructors

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // init Android notifications
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('foreground');

    // init iOS notifications
    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {}
    );

    // create notification settings
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS
    );

    // init notifications with settings
    await notificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {}
    );
  }

  // get notification details
  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max),
      iOS: DarwinNotificationDetails()
    );
  }

  // show notification to the user
  Future showNotification(tz.TZDateTime scheduledDate, {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      await notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }

  // unschedule notification
  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
