import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/screens/prayer_time/city/city_state.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_viewmodel.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';

final cityViewModel =
    StateNotifierProvider.autoDispose<CityViewModel, CityState>((ref) {
  return CityViewModel(
    geocodingService: ref.watch(geocodingService),
    listCity: ref.watch(prayerTimeViewModel.select(
      (value) => value.listCity.valueOrNull ?? [],
    )),
    CityState(
        search: TextEditingController(),
        currentCity: const AsyncData(''),
        searchText: ''),
  );
});

class CityViewModel extends StateNotifier<CityState> {
  CityViewModel(
    super.state, {
    required GeocodingService geocodingService,
    required this.listCity,
  }) : _geocodingService = geocodingService;

  final GeocodingService _geocodingService;
  final List<CityModel> listCity;

  void getCurrentCity() async {
    try {
      final resultPermission = await Permission.location.request();
      if (resultPermission.isPermanentlyDenied) {
        openAppSettings();
        return;
      }
      state = state.copyWith(currentCity: const AsyncLoading());
      final result = await _geocodingService.getCity();
      state.search.text = result;
      final filterResult = listCity.getFilterResult(result);
      if (filterResult.isEmpty) return;
      state = state.copyWith(
        currentCity: const AsyncData(''),
      );
    } catch (e) {
      state = state.copyWith(currentCity: AsyncError(e, StackTrace.current));
    }
  }

  void onChange(String val) {
    state = state.copyWith();
  }
}
