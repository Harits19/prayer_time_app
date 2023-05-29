import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/screens/bottom_navigation/bottom_navigation_screen.dart';
import 'package:prayer_time_app/services/notification_service.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';
import 'package:prayer_time_app/services/work_manager_service.dart';
import 'package:workmanager/workmanager.dart';

// TODO refactor riverpod provider change to mvvm

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await SharedPrefService.initService();
  await Workmanager().cancelAll();
  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: kDebugMode,
  );
  await Workmanager().registerPeriodicTask(
    simplePeriodicTask,
    simplePeriodicTask,
    initialDelay: const Duration(seconds: 10),
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      home: const BottomNavigationScreen(),
    );
  }
}
