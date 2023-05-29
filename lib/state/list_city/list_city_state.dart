import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';

final listCityState = FutureProvider(
  (ref) => PrayerTimeServices().getListCity(),
);
