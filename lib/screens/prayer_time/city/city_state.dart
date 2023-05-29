import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/models/response_city_model.dart';

class CityState {
  final TextEditingController search;
  final AsyncValue<String> currentCity;

  CityState({
    required this.search,
    required this.currentCity,
  });

  CityState copyWith({
    AsyncValue<String>? currentCity,
  }) {
    return CityState(
      search: search,
      currentCity: currentCity ?? this.currentCity,
    );
  }

  bool get isLoading => currentCity.isLoading;
}
