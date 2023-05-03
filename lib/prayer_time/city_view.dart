import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/prayer_time/loading_view.dart';
import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/state/current_city/current_city_state.dart';
import 'package:prayer_time_app/state/list_city/list_city_state.dart';
import 'package:prayer_time_app/state/prayer_time/prayer_time_state.dart';

class CityView extends ConsumerStatefulWidget {
  const CityView({
    super.key,
  });

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
    final cityWatch = ref.watch(listCityState);
    final currentCityWatch = ref.watch(currentCityState);
    final listCity = cityWatch.valueOrNull ?? [];
    var resultSearch = <CityModel>[];
    if (search.text.isNotEmpty) {
      resultSearch = listCity.getFilterResult(search.text).toList();
    }

    return LoadingView(
      isLoading: cityWatch.isLoading || currentCityWatch.isLoading,
      error: currentCityWatch.error ?? cityWatch.error,
      child: SafeArea(
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
                    onPressed: () {
                      ref.invalidate(currentCityState);
                      ref.read(currentCityState.future);
                      search.text = currentCityWatch.valueOrNull ?? '';
                      setState(() {});
                    },
                    icon: const Icon(Icons.gps_fixed),
                  ),
                ),
              ),
            ),
            const Divider(),
            ...(search.text.isNotEmpty ? resultSearch : listCity).map(
              (e) => InkWell(
                onTap: () async {
                  ref.watch(prayerTimeState.notifier).updateId(e.id);
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
    );
  }
}
