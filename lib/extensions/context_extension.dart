import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  void showError(Object err) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          err.toString(),
        ),
      ),
    );
  }
}
