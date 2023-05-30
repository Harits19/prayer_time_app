import 'package:flutter/material.dart';
import 'package:prayer_time_app/main.dart';
import 'package:prayer_time_app/screens/views/loading_view.dart';

class ViewUtil {
  static void showLoading() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) => const LoadingViewNew(),
      );
    });
  }

  static void dismissLoading() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pop(navigatorKey.currentContext!);
    });
  }

  static Widget showError(BuildContext context, Object err) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            err.toString(),
          ),
        ),
      );
    });
    return SizedBox();
  }
}
