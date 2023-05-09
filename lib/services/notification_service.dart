import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';

class NotificationService {
  static final _notificationService = NotificationService._internal();
  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static Future<void> init() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_name');

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    print("called onDidReceiveNotificationResponse");
  }

  static void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse response) {
    print("called onDidReceiveBackgroundNotificationResponse");
  }

  static show({required String title, required String body}) {
    NotificationService.flutterLocalNotificationsPlugin.show(
      TimeOfDay.now().toDouble().toInt(),
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "Prayer Time",
          "Prayer Time",
          playSound: true,
          sound: RawResourceAndroidNotificationSound("adzan"),
          
        ),
      ),
    );
  }
}
