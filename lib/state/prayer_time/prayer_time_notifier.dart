
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';
import 'package:prayer_time_app/state/prayer_time/prayer_time_state.dart';
import 'package:prayer_time_app/state/selected_city/selected_city_state.dart';


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