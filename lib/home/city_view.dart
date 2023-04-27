import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/extensions/context_extension.dart';
import 'package:prayer_time_app/main.dart';
import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/services/geocoding_service.dart';

class CityView extends ConsumerStatefulWidget {
  const CityView({
    super.key,
    required this.onChangeCity,
  });

  final ValueChanged<CityModel> onChangeCity;

  @override
  ConsumerState<CityView> createState() => _CityViewState();
}

class _CityViewState extends ConsumerState<CityView> {
  final search = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    search.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cityWatch = ref.watch(cityState);
    final currentCity = ref.watch(currentCityState);
    final listCity = cityWatch.value ?? [];
    var resultSearch = <CityModel>[];
    if (search.text.isNotEmpty) {
      resultSearch = listCity.where(
        (element) {
          final lokasi = element.lokasi;
          if (lokasi == null) return false;

          return search.text.toLowerCase().contains(
                lokasi.toLowerCase(),
              );
        },
      ).toList();
    }

    return SafeArea(
      child: cityWatch.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(KSize.s16),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: KSize.s16),
                  child: TextField(
                    controller: search,
                    onChanged: (val) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: IconButton(
                        onPressed: () {
                          context.showLoading();
                          GeocodingService.getCity().then((value) {
                            search.text = value;
                            setState(() {});
                            Navigator.pop(context);
                          });
                        },
                        icon: const Icon(Icons.gps_fixed),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ...(search.text.isNotEmpty ? resultSearch : listCity).map(
                  (e) => InkWell(
                    onTap: () {
                      widget.onChangeCity(e);
                      Navigator.pop(context);
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(KSize.s16),
                        child: Text(e.lokasi ?? ''),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
