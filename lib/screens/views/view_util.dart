import 'package:flutter/material.dart';
import 'package:prayer_time_app/screens/views/loading_view.dart';

class ViewUtil {
  static void showLoading(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const LoadingView(),
        );
      }
    });
  }

  static void dismissLoading(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.mounted) {
        Navigator.pop(context);
      }
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
    return const SizedBox();
  }
}
