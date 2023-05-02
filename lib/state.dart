import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';

final prayerTimeState =
    StateNotifierProvider<PrayerTimeNotifier, PrayerTimeState>(
  (ref) {
    return PrayerTimeNotifier(ref)..init();
  },
);

class PrayerTimeState {
  final PrayerTimeModel? prayerTime;
  final bool isLoading;
  final Object? error;

  PrayerTimeState({this.prayerTime, this.isLoading = false, this.error});
}

class PrayerTimeNotifier extends StateNotifier<PrayerTimeState> {
  PrayerTimeNotifier(this.ref) : super(PrayerTimeState());

  final Ref ref;

  void init() async {
    try {
      state = PrayerTimeState(
        isLoading: true,
      );
      final id = await ref.watch(selectedCityState.future);
      
      final resultFromCache =
          SharedPrefService.getCache(SharePrefKey.prayerTime);
      if (resultFromCache != null) {
        final cacheModel = PrayerTimeModel.fromJson(resultFromCache);
        state = PrayerTimeState(
          error: null,
          isLoading: false,
          prayerTime: cacheModel,
        );
      }

      final resultFromApi = await PrayerTimeServices.getPrayerTime(id);
      state = PrayerTimeState(
        error: null,
        isLoading: false,
        prayerTime: resultFromApi,
      );

      if (resultFromApi?.toJson() != null) {
        SharedPrefService.saveCache(
            SharePrefKey.prayerTime, resultFromApi!.toJson());
      }
    } catch (e) {
      state = PrayerTimeState(
        error: e,
        isLoading: false,
        prayerTime: state.prayerTime,
      );
    }
  }
}

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
