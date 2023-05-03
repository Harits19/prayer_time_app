import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/extensions/city_model_extension.dart';
import 'package:prayer_time_app/state/current_city/current_city_state.dart';
import 'package:prayer_time_app/state/list_city/list_city_state.dart';

final newCityIdState = StateProvider<String?>((ref) => null);

final selectedCityState = FutureProvider<String>(
  (ref) async {
    final newCityId = ref.watch(newCityIdState);
    if (newCityId != null) return newCityId;
    final currentCityWatch = await ref.watch(currentCityState.future);
    final listCityWatch = await ref.watch(listCityState.future);
    var defaultId = '0101';
    final filteredList = listCityWatch.getFilterResult(currentCityWatch);
    if (filteredList.isEmpty) {
      return defaultId;
    }
    return filteredList.first.id ?? defaultId;
  },
);
