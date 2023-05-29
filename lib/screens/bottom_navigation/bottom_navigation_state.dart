class BottomNavigationState {
  final int selectedIndex;

  BottomNavigationState({required this.selectedIndex});

  BottomNavigationState copyWith({
    int? selectedIndex,
  }) {
    return BottomNavigationState(
        selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}
