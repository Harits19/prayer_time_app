import 'package:flutter/material.dart';

class LoadingViewNew extends StatelessWidget {
  const LoadingViewNew({
    super.key,
    this.size,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
