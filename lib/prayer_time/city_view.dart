import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/prayer_time/loading_view.dart';
import 'package:prayer_time_app/models/response_city_model.dart';
import 'package:prayer_time_app/state/auto_detect_location/auto_detect_location_state.dart';
import 'package:prayer_time_app/state/current_city/current_city_state.dart';
import 'package:prayer_time_app/state/list_city/list_city_state.dart';
import 'package:prayer_time_app/state/prayer_time/prayer_time_state.dart';
import 'package:permission_handler/permission_handler.dart';

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
    final listCityWatch = ref.watch(listCityState);
    final currentCityWatch = ref.watch(currentCityState);
    final listCity = listCityWatch.valueOrNull ?? [];
    var resultSearch = <CityModel>[];
    if (search.text.isNotEmpty) {
      resultSearch = listCity.getFilterResult(search.text).toList();
    }

    final isLoading = currentCityWatch.isLoading || listCityWatch.isLoading;

    return LoadingView(
      isLoading: isLoading,
      error: currentCityWatch.error ?? listCityWatch.error,
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
                    var status = await Permission.location.request();

                    if (status == PermissionStatus.permanentlyDenied) {
                      await ph.openAppSettings();
                      return;
                    }
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
          SwitchListTile(
            value: ref.watch(autoDetectLocationState),
            onChanged: ref.read(autoDetectLocationState.notifier).setValue,
            title: const Text('Deteksi otomatis lokasi saat mulai'),
          ),
          if (!isLoading)
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
    );
  }
}
