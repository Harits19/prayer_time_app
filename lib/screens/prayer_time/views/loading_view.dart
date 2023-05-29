import 'package:flutter/material.dart';
import 'package:prayer_time_app/extensions/context_extension.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({
    super.key,
    required this.child,
    this.isLoading = false,
    this.error,
  });

  final Widget child;
  final bool isLoading;
  final Object? error;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void didUpdateWidget(covariant LoadingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.error != widget.error && widget.error != null) {
      Future.delayed(Duration.zero).then((value) {
        context.showError(widget.error!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: widget.child),
        if (widget.isLoading)
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
