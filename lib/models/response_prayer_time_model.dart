import 'package:flutter/material.dart';
import 'package:prayer_time_app/constans/k_type.dart';
import 'package:prayer_time_app/extensions/string_extension.dart';

class ResponsePrayerTimeModel {
  final bool? status;
  final PrayerTimeModel? data;

  ResponsePrayerTimeModel({
    this.status,
    this.data,
  });

  ResponsePrayerTimeModel.fromJson(Map<String, dynamic> json)
      : status = json['status'] as bool?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? PrayerTimeModel.fromJson(json['data'] as Map<String, dynamic>)
            : null;

  Map<String, dynamic> toJson() => {'status': status, 'data': data?.toJson()};
}

class PrayerTimeModel {
  final String? id;
  final String? lokasi;
  final String? daerah;
  final Koordinat? koordinat;
  final Jadwal? jadwal;

  PrayerTimeModel({
    this.id,
    this.lokasi,
    this.daerah,
    this.koordinat,
    this.jadwal,
  });

  PrayerTimeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        lokasi = json['lokasi'] as String?,
        daerah = json['daerah'] as String?,
        koordinat = (json['koordinat'] as Map<String, dynamic>?) != null
            ? Koordinat.fromJson(json['koordinat'] as Map<String, dynamic>)
            : null,
        jadwal = (json['jadwal'] as Map<String, dynamic>?) != null
            ? Jadwal.fromJson(json['jadwal'] as Map<String, dynamic>)
            : null;

  Json toJson() => {
        'id': id,
        'lokasi': lokasi,
        'daerah': daerah,
        'koordinat': koordinat?.toJson(),
        'jadwal': jadwal?.toJson()
      };
}

class Koordinat {
  final double? lat;
  final double? lon;
  final String? lintang;
  final String? bujur;

  Koordinat({
    this.lat,
    this.lon,
    this.lintang,
    this.bujur,
  });

  Koordinat.fromJson(Map<String, dynamic> json)
      : lat = json['lat'] as double?,
        lon = json['lon'] as double?,
        lintang = json['lintang'] as String?,
        bujur = json['bujur'] as String?;

  Map<String, dynamic> toJson() =>
      {'lat': lat, 'lon': lon, 'lintang': lintang, 'bujur': bujur};
}

class Jadwal {
  final String? tanggal;
  final String? imsak;
  final String? subuh;
  final String? terbit;
  final String? dhuha;
  final String? dzuhur;
  final String? ashar;
  final String? maghrib;
  final String? isya;
  final String? date;

  Jadwal({
    this.tanggal,
    this.imsak,
    this.subuh,
    this.terbit,
    this.dhuha,
    this.dzuhur,
    this.ashar,
    this.maghrib,
    this.isya,
    this.date,
  });

  Jadwal.fromJson(Map<String, dynamic> json)
      : tanggal = json['tanggal'] as String?,
        imsak = json['imsak'] as String?,
        subuh = json['subuh'] as String?,
        terbit = json['terbit'] as String?,
        dhuha = json['dhuha'] as String?,
        dzuhur = json['dzuhur'] as String?,
        ashar = json['ashar'] as String?,
        maghrib = json['maghrib'] as String?,
        isya = json['isya'] as String?,
        date = json['date'] as String?;

  Map<String, dynamic> toJson() => {
        'tanggal': tanggal,
        'imsak': imsak,
        'subuh': subuh,
        'terbit': terbit,
        'dhuha': dhuha,
        'dzuhur': dzuhur,
        'ashar': ashar,
        'maghrib': maghrib,
        'isya': isya,
        'date': date
      };

  Map<String, TimeOfDay?> toMappedTimeOfDay() {
    return {
      'Imsak': imsak,
      'Shubuh': subuh,
      'Terbit': terbit,
      'Dhuha': dhuha,
      'Dzuhur': dzuhur,
      'Ashar': ashar,
      'Magrib': maghrib,
      'Isya': isya,
    }.map((key, value) => MapEntry(key, value.toTimeOfDay()));
  }
}
