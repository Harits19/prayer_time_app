import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/screens/bottom_navigation/bottom_navigation_state.dart';

final bottomNavigationViewModel =
    StateNotifierProvider<BottomNavigationVieModel, BottomNavigationState>(
        (ref) {
  return BottomNavigationVieModel(
    BottomNavigationState(selectedIndex: 0),
  );
});

class BottomNavigationVieModel extends StateNotifier<BottomNavigationState> {
  BottomNavigationVieModel(super.state);


  void setSelectedIndex(int index) {
    state = state.copyWith(
      selectedIndex: index,
    );
  }
}
