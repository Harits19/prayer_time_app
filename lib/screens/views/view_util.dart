import 'package:flutter/material.dart';

class ViewUtil {
  static void showLoading(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }

  static void dismissLoading(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.pop(context);
    });
  }
}
