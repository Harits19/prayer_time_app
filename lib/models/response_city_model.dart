

class CityModel {
  final String? id;
  final String? lokasi;

  CityModel({
    this.id,
    this.lokasi,
  });

  CityModel.fromJson(Map<String, dynamic> json)
    : id = json['id'] as String?,
      lokasi = json['lokasi'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'lokasi' : lokasi
  };
}
