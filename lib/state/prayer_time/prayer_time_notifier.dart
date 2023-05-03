import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';
import 'package:prayer_time_app/state/current_city/current_city_state.dart';
import 'package:prayer_time_app/state/list_city/list_city_state.dart';
import 'package:prayer_time_app/state/prayer_time/prayer_time_state.dart';

class PrayerTimeNotifier extends StateNotifier<PrayerTimeState> {
  PrayerTimeNotifier(this.ref) : super(PrayerTimeState());

  final Ref ref;

  void init() async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final currentCityWatch = await ref.watch(currentCityState.future);
      final listCityWatch = await ref.watch(listCityState.future);
      final filteredList = listCityWatch.getFilterResult(currentCityWatch);
      final currentCityId = filteredList.first.id;

      state = state.copyWith(
        selectedCityId: currentCityId,
      );

      final resultFromCache =
          SharedPrefService.getCache(SharePrefKey.prayerTime);

      if (resultFromCache != null) {
        final cacheModel = PrayerTimeModel.fromJson(resultFromCache);
        state = state.copyWith(
          error: null,
          isLoading: false,
          prayerTime: cacheModel,
        );
      }

      final resultFromApi = await PrayerTimeServices.getPrayerTime(
        state.selectedCityId,
      );

      state = state.copyWith(
        error: null,
        isLoading: false,
        prayerTime: resultFromApi,
      );

      saveCache();
    } catch (e) {
      state = state.copyWith(
        error: e,
        isLoading: false,
        prayerTime: state.prayerTime,
      );
    }
  }

  void updateId(String? id) async {
    state = state.copyWith(
      selectedCityId: id,
      isLoading: true,
    );
    final resultFromApi = await PrayerTimeServices.getPrayerTime(
      state.selectedCityId,
    );

    state = state.copyWith(
      isLoading: false,
      prayerTime: resultFromApi,
    );
    saveCache();
  }

  void saveCache() {
    SharedPrefService.saveCache(
        SharePrefKey.prayerTime, state.prayerTime?.toJson());
  }
}