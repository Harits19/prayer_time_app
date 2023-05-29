import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/screens/bottom_navigation/bottom_navigation_viewmodel.dart';
import 'package:prayer_time_app/models/bottom_navigation_model.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_screen.dart';
import 'package:prayer_time_app/screens/qibla/qibla_screen.dart';

class BottomNavigationScreen extends ConsumerStatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  ConsumerState<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends ConsumerState<BottomNavigationScreen> {

  @override
  Widget build(BuildContext context) {
    final listScreen = [
      BottomNavigationModel(
        barItem: const BottomNavigationBarItem(
          icon: Icon(Icons.watch_later),
          label: 'Prayer Time',
        ),
        screen: const PrayerTimeScreen(),
      ),
      BottomNavigationModel(
        barItem: const BottomNavigationBarItem(
          icon: Icon(Icons.keyboard_arrow_up_rounded),
          label: 'Qibla',
        ),
        screen: const QiblaScreen(),
      )
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: ref.watch(bottomNavigationViewModel.select((value) => value.selectedIndex)),
        onTap: ref.read(bottomNavigationViewModel.notifier).setSelectedIndex,
        items: listScreen.map((e) => e.barItem).toList(),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: ref.watch(bottomNavigationViewModel.select((value) => value.selectedIndex)),
          children: listScreen.map((e) => e.screen).toList(),
        ),
      ),
    );
  }
}
