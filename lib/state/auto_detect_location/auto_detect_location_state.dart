import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/state/auto_detect_location/auto_detect_location_notifier.dart';

final autoDetectLocationState =
    StateNotifierProvider<AutoDetectLocationNotifier, bool>((ref) {
  return AutoDetectLocationNotifier()..init();
});
