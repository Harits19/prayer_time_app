import 'package:flutter/material.dart';

class LoadingViewNew extends StatelessWidget {
  const LoadingViewNew({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
