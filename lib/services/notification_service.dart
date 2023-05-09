import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

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

    initializeTimeZones();

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

  static NotificationDetails get notificationDetail {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_time',
        'flutterfcm',
        channelDescription: "flutterfcm",
        playSound: true,
        sound: RawResourceAndroidNotificationSound("adzan"),
      ),
    );
  }

  static Future<void> scheduleNotification(
    TZDateTime scheduleTime,
    String prayerName,
    String location,
  ) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      TimeOfDay(hour: scheduleTime.hour, minute: scheduleTime.minute)
          .toDouble(),
      "Waktunya adzan $prayerName",
      "Untuk wilayah $location dan sekitarnya",
      scheduleTime,
      notificationDetail,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelAll() {
    return flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> show() async {
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(10),
      "Waktunya adzan",
      "Untuk wilayah dan sekitarnya",
      notificationDetail,
    );
  }
}
