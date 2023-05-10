import 'package:prayer_time_app/models/response_city_model.dart';

extension ListCityModelExtension on List<CityModel> {
  List<CityModel> getFilterResult(String? key) {
    if (key?.isEmpty ?? true) return [];
    const kabupaten = "kabupaten";
    const kota = "kota";
    key = key!.toLowerCase().replaceAll(kabupaten, "");
    return where(
      (element) {
        final lokasi = element.lokasi?.toLowerCase().replaceAll(kota, "");
        if (lokasi == null) return false;

        final check1 = key!.contains(
          lokasi,
        );
        final check2 = lokasi.contains(
          key,
        );

        return check1 || check2;
      },
    ).toList();
  }
}
