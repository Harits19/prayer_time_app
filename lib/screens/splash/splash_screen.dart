import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/context_extension.dart';
import 'package:prayer_time_app/screens/bottom_navigation/bottom_navigation_screen.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(sharedPrefService).initService();
      if (context.mounted) {
        context.push(const BottomNavigationScreen());
      }
    });
    return Scaffold(
      body: Center(
        child: Image.asset('assets/mosque.png'),
      ),
    );
  }
}
