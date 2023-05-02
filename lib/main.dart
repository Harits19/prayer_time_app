import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:prayer_time_app/home/home_screen.dart';
import 'package:prayer_time_app/playground.dart';
import 'package:prayer_time_app/services/shared_pref_service.dart';

// TODO save cache to local storage
// TODO implement widget
// TODO add qibla

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefService.initService();
  runApp(const ProviderScope(child: MyApp()));
}

void mainTemp() {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyAppPlayground());
}

// Called when Doing Background Work initiated from Widget
Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'updatecounter') {
    int counter = 0;
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0)
        .then((value) {
      counter = value ?? 0;
      counter++;
    });
    await HomeWidget.saveWidgetData<int>('_counter', counter);
    await HomeWidget.updateWidget(
        name: 'AppWidgetProvider', iOSName: 'AppWidgetProvider');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      home: const HomeScreen(),
    );
  }
}
