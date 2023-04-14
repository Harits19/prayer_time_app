import 'dart:convert';

import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:http/http.dart' as http;

class PrayerTimeServices {
  static Future<PrayerTimeModel?> getPrayerTime() async {
    final url =
        Uri.https('api.myquran.com', '/v1/sholat/jadwal/1301/2023/4/13');
    final response = await http.get(url);

    final parsedResponse = ResponsePrayerTimeModel.fromJson(
      jsonDecode(response.body),
    );
    return parsedResponse.data;
  }
}
