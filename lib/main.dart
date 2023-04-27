import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/home/home_screen.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';

final prayerTimeState = FutureProvider.family<PrayerTimeModel?, String>(
  (ref, id) => PrayerTimeServices.getPrayerTime(id),
);

final cityState = FutureProvider(
  (ref) => PrayerTimeServices.getAllCity(),
);

final currentCityState = FutureProvider(
  (ref) => GeocodingService.getCity(),
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
