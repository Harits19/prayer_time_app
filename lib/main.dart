import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/bottom_navigation/bottom_navigation_screen.dart';
import 'package:prayer_time_app/services/notification_service.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';
import 'package:prayer_time_app/services/work_manager_service.dart';
import 'package:workmanager/workmanager.dart';

// TODO auto refresh prayer time on widget
// TODO auto detect location

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await SharedPrefService.initService();
  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerPeriodicTask(
    simplePeriodicTask,
    simplePeriodicTask,
    initialDelay: Duration(seconds: 10),
  );
  // await HomeWidget.registerBackgroundCallback(backgroundCallback);
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
