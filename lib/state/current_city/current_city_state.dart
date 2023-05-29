import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';

final currentCityState = FutureProvider(
  (ref) => ref.watch(geocodingServiceProvider).getCity(),
);
