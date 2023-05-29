import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/screens/prayer_time/city/city_viewmodel.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_viewmodel.dart';
import 'package:prayer_time_app/screens/prayer_time/views/loading_view.dart';

class CityScreen extends ConsumerStatefulWidget {
  const CityScreen({
    super.key,
  });

  @override
  ConsumerState<CityScreen> createState() => _CityViewState();
}

class _CityViewState extends ConsumerState<CityScreen> {
  @override
  Widget build(BuildContext context) {
    final listCity = ref.watch(
        prayerTimeViewModel.select((value) => value.listCity.value ?? []));
    final search = ref.watch(cityViewModel.select((value) => value.search));

    return LoadingView(
      isLoading: ref.watch(cityViewModel.select((value) => value.isLoading)),
      child: ListView(
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
                  onPressed: () async {
                    ref.read(cityViewModel.notifier).getCurrentCity();
                  },
                  icon: const Icon(Icons.gps_fixed),
                ),
              ),
            ),
          ),
          SwitchListTile(
            value: false,
            onChanged: (val) {},
            title: const Text('Deteksi otomatis lokasi saat mulai'),
          ),
          ...(search.text.isNotEmpty
                  ? listCity.getFilterResult(search.text).toList()
                  : listCity)
              .map(
            (e) => InkWell(
              onTap: () async {
                ref.read(prayerTimeViewModel.notifier).setSelectedCity(e);
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
