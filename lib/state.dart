import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
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

final selectedCityState = FutureProvider<String>(
  (ref) async {
    final newCityId = ref.watch(newCityIdState);
    if (newCityId != null) return newCityId;
    final currentCityWatch = await ref.watch(currentCityState.future);
    final listCityWatch = await ref.watch(listCityState.future);
    var defaultId = '0101';
    final filteredList = listCityWatch.getFilterResult(currentCityWatch);
    if (filteredList.isEmpty) {
      return defaultId;
    }
    return filteredList.first.id ?? defaultId;
  },
);

