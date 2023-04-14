import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:prayer_time_app/services/prayer_time_services.dart';

class PrayerTimeState extends StateNotifier<PrayerTimeModel?> {
  PrayerTimeState(super.state);

  void getPrayerTime() async{
   state = await PrayerTimeServices.getPrayerTime();
  }
}
