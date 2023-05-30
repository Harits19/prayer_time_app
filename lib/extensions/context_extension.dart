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

  Future<T?> push<T extends Object?>(Widget route) {
    return Navigator.push(this, MaterialPageRoute(builder: (context) => route));
  }
}
