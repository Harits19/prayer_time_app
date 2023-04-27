import 'dart:convert';

import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:http/http.dart' as http;

class PrayerTimeServices {
  static const _baseUrl = 'api.myquran.com';

  static Future<PrayerTimeModel?> getPrayerTime(String id) async {
    final now = DateTime.now();

    final url = Uri.https(_baseUrl, '/v1/sholat/jadwal/${id}/${now.year}/${now.month}/${now.day}');
    final response = await http.get(url);

    final parsedResponse = ResponsePrayerTimeModel.fromJson(
      jsonDecode(response.body),
    );
    return parsedResponse.data;
  }

  static Future<List<CityModel>> getAllCity() async {
    final url = Uri.https(_baseUrl, '/v1/sholat/kota/semua');
    final response = await http.get(url);

    final parsedResponse = (jsonDecode(response.body) as List)
        .map((e) => CityModel.fromJson(e))
        .toList();

    return parsedResponse;
  }
}
