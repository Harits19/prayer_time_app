import 'dart:convert';

import 'package:home_widget/home_widget.dart';
import 'package:prayer_time_app/constans/k_type.dart';

enum HomeWidgetKey { prayerTime }

const kAppWidgetProvider = 'AppWidgetProvider';

class HomeWidgetService {
  static Future<void> updatePrayerWidget(Json? json) async {
    if (json == null) return;

    await HomeWidget.saveWidgetData<String>(HomeWidgetKey.prayerTime.name, jsonEncode(json));
    await HomeWidget.updateWidget(
      name: kAppWidgetProvider,
      iOSName: kAppWidgetProvider,
      qualifiedAndroidName: 'com.example.prayer_time_app.$kAppWidgetProvider'
    );
  }
}
