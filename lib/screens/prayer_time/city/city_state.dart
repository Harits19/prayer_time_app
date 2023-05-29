import 'package:flutter/material.dart';

class CityState {
  final TextEditingController search;

  CityState({required this.search});

  CityState copyWith() {
    return CityState(search: search);
  }
}
