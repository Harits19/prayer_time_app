import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/constans/k_text_style.dart';
import 'package:prayer_time_app/extensions/int_extension.dart';
import 'package:prayer_time_app/extensions/string_extension.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:prayer_time_app/home/city_view.dart';
import 'package:prayer_time_app/home/loading_view.dart';
import 'package:prayer_time_app/home/prayer_view.dart';
import 'package:prayer_time_app/main.dart';
import 'package:prayer_time_app/models/response_prayer_time_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TimeOfDay? countDown;
  Timer? timer;
  MapEntry<String, TimeOfDay?>? selectedPrayer;
  int second = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      runTimer();
    });
  }

  runTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (selectedPrayer == null) return;
      countDown = selectedPrayer?.value.different(TimeOfDay.now());
      second = DateTime.now().second;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final prayerWatch = ref.watch(prayerTimeState);
    final prayerTime = prayerWatch.value;
    final schedule = prayerTime?.jadwal;
    final mappedPrayer =
        schedule?.toMappedTimeOfDay() ?? Jadwal().toMappedTimeOfDay();
    selectedPrayer = TimeOfDay.now().nextPrayer(mappedPrayer);
    final currentPrayer = TimeOfDay.now().currentPrayer(mappedPrayer);
    final nextPrayer = selectedPrayer?.key ?? '-';
    return LoadingView(
      isLoading: prayerWatch.isLoading,
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(KSize.s16),
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sekarang waktu',
                        style: TextStyle(
                          fontSize: KSize.s12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        currentPrayer?.key ?? "-",
                        style: TextStyle(
                          fontSize: KSize.s32,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => const CityView(),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.zero,
                            child: Padding(
                              padding: const EdgeInsets.all(KSize.s4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: KSize.s12,
                                  ),
                                  const SizedBox(
                                    width: KSize.s4,
                                  ),
                                  Text(
                                    prayerTime?.lokasi.toCapitalize() ?? '-',
                                    style: const TextStyle(
                                      fontSize: KSize.s12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: KSize.s12,
                        ),
                        Text(
                          '- ${countDown?.to24Format()}:${(60 - second).addLeadingZeroIfNeeded()}',
                          style: KTextStyle.date.copyWith(
                              color: Theme.of(context).colorScheme.secondary),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: KSize.s16,
              ),
              Row(
                children: [
                  Text(
                    schedule?.date.formatDateGeorgian() ?? '-',
                    style: KTextStyle.date,
                  ),
                  const Spacer(),
                  Text(
                    schedule?.date.formatDateHijri() ?? '-',
                    style: KTextStyle.date,
                  ),
                ],
              ),
              const SizedBox(
                height: KSize.s16,
              ),
              const Divider(),
              const SizedBox(
                height: KSize.s16,
              ),
              if (mappedPrayer != null)
                ...mappedPrayer.entries.map(
                  (e) => PrayerView(
                    isActive: e.key == nextPrayer,
                    prayer: e.key,
                    time: e.value?.format(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
