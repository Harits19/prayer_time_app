import 'package:flutter/material.dart';
import 'package:prayer_time_app/extensions/context_extension.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    super.key,
    required this.child,
    required this.isLoading,
    this.error,
  });

  final Widget child;
  final bool isLoading;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      Future.delayed(Duration.zero).then((value) {
        context.showError(error!);
      });
    }
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
      ],
    );
  }
}
