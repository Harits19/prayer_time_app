import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prayer_time_app/models/bottom_navigation_model.dart';
import 'package:prayer_time_app/prayer_time/prayer_time_screen.dart';
import 'package:prayer_time_app/qibla/qibla_screen.dart';
import 'package:prayer_time_app/services/notification_service.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

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
      floatingActionButton: FloatingActionButton(onPressed: () {
        
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (value) {
          selectedIndex = value;
          setState(() {});
        },
        items: listScreen.map((e) => e.barItem).toList(),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: listScreen.map((e) => e.screen).toList(),
        ),
      ),
    );
  }
}
