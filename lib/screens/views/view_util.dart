import 'package:flutter/material.dart';
import 'package:prayer_time_app/main.dart';

class ViewUtil {
  static void showLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  static void dismissLoading() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pop(navigatorKey.currentContext!);
    });
  }
}
