import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CityState {
  final TextEditingController search;
  final AsyncValue<String> currentCity;
  final String searchText;

  CityState({
    required this.search,
    required this.currentCity,
    required this.searchText,
  });

  CityState copyWith({
    AsyncValue<String>? currentCity,
    String? searchText,
  }) {
    return CityState(
      search: search,
      currentCity: currentCity ?? this.currentCity,
      searchText: search.text,
    );
  }

  bool get isLoading => currentCity.isLoading;
  Object? get error => currentCity.error;
}
