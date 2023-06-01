import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/screens/prayer_time/city/city_viewmodel.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_viewmodel.dart';
import 'package:prayer_time_app/screens/prayer_time/views/loading_view.dart';
import 'package:prayer_time_app/screens/views/loading_view.dart';
import 'package:prayer_time_app/screens/views/view_util.dart';

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
        prayerTimeViewModel.select((value) => value.listCity.valueOrNull ?? []));
    final search = ref.watch(cityViewModel.select((value) => value.searchText));

    return LoadingView(
      isLoading: ref.watch(cityViewModel.select((value) => value.isLoading)),
      error: ref.watch(cityViewModel.select((value) => value.error)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(KSize.s16),
            child: Column(
              children: [
                TextField(
                  controller:
                      ref.watch(cityViewModel.select((value) => value.search)),
                  onChanged: ref.read(cityViewModel.notifier).onChange,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Auto detect location'),
                    ref
                        .watch(prayerTimeViewModel
                            .select((value) => value.autoDetectLocation))
                        .when(
                          loading: () => const LoadingViewNew(),
                          error: (error, stackTrace) =>
                              ViewUtil.showError(context, error),
                          data: (data) => Switch(
                            value: data,
                            onChanged: ref
                                .read(prayerTimeViewModel.notifier)
                                .setAutoDetectLocation,
                          ),
                        ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(KSize.s16),
              children: [
                ...(search.isNotEmpty
                        ? listCity.getFilterResult(search).toList()
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
          ),
        ],
      ),
    );
  }
}
