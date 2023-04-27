import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/home/home_screen.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';

final prayerTimeState = FutureProvider<PrayerTimeModel?>(
  (ref) async {
    final id = await ref.watch(selectedCityState.future);
    return PrayerTimeServices.getPrayerTime(id);
  },
);

final listCityState = FutureProvider(
  (ref) => PrayerTimeServices.getAllCity(),
);

final currentCityState = FutureProvider(
  (ref) => GeocodingService.getCity(),
);
final newCityIdState = StateProvider<String?>((ref) => null);

final selectedCityState = FutureProvider<String>((ref) async {
  final newCityId = ref.watch(newCityIdState);
  if (newCityId != null) return newCityId;
  final currentCityWatch = await ref.watch(currentCityState.future);
  final cityWatch = await ref.watch(listCityState.future);
  return cityWatch.getFilterResult(currentCityWatch).first.id ?? '0101';
});

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
