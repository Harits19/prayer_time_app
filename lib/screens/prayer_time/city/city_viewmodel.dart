import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/screens/prayer_time/city/city_state.dart';

final cityViewModel = StateNotifierProvider.autoDispose<CityViewModel, CityState>((ref) {
  return CityViewModel(
    CityState(
      search: TextEditingController(),
    ),
  );
});

class CityViewModel extends StateNotifier<CityState> {
  CityViewModel(super.state);
}
