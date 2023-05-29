import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';
import 'package:http/http.dart' as http;

final prayerTimeService = Provider<PrayerTimeServices>((ref) {
  return PrayerTimeServices();
});

class PrayerTimeServices {
  static const _baseUrl = 'api.myquran.com';

  Future<PrayerTimeModel?> getPrayerTime(String id) async {
    final now = DateTime.now();

    final url = Uri.https(
      _baseUrl,
      '/v1/sholat/jadwal/$id/${now.year}/${now.month}/${now.day}',
    );
    final response = await http.get(url);

    final parsedResponse = ResponsePrayerTimeModel.fromJson(
      jsonDecode(response.body),
    );
    return parsedResponse.data;
  }

  Future<List<CityModel>> getListCity() async {
    final url = Uri.https(_baseUrl, '/v1/sholat/kota/semua');
    final response = await http.get(url);

    final parsedResponse = (jsonDecode(response.body) as List)
        .map((e) => CityModel.fromJson(e))
        .toList();

    return parsedResponse;
  }
}
