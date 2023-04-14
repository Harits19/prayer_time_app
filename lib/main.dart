import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/home/home_screen.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/state/prayer_time_state.dart';

final prayerTimeState = StateNotifierProvider<PrayerTimeState, PrayerTimeModel?>(
  (ref) => PrayerTimeState(null)..getPrayerTime(),
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
