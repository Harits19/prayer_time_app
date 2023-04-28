import 'package:prayer_time_app/models/response_city_model.dart';

extension ListCityModelExtension on List<CityModel> {
  List<CityModel> getFilterResult(String? key) {
    if (key?.isEmpty ?? true) return [];
    return where(
      (element) {
        final lokasi = element.lokasi;
        if (lokasi == null) return false;

        final check1 = key!.toLowerCase().contains(
              lokasi.toLowerCase(),
            );
        final check2 = lokasi.toLowerCase().contains(
              key.toLowerCase(),
            );

        return check1 || check2;
      },
    ).toList();
  }
}
