import 'package:prayer_time_app/models/response_city_model.dart';

extension ListCityModelExtension on List<CityModel> {
  List<CityModel> getFilterResult(String? key) {
    if (key?.isEmpty ?? true) return [];
    return where(
      (element) {
        final lokasi = element.lokasi;
        if (lokasi == null) return false;

        return key!.toLowerCase().contains(
              lokasi.toLowerCase(),
            );
      },
    ).toList();
  }
}
