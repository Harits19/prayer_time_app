import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/constans/k_text_style.dart';
import 'package:prayer_time_app/extensions/string_extension.dart';
import 'package:prayer_time_app/extensions/time_of_day_extension.dart';
import 'package:prayer_time_app/screens/prayer_time/prayer_time_viewmodel.dart';
import 'package:prayer_time_app/screens/prayer_time/city/city_screen.dart';
import 'package:prayer_time_app/screens/prayer_time/views/loading_view.dart';
import 'package:prayer_time_app/screens/prayer_time/views/prayer_view.dart';

class PrayerTimeScreen extends ConsumerStatefulWidget {
  const PrayerTimeScreen({super.key});

  @override
  ConsumerState<PrayerTimeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<PrayerTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return LoadingView(
      isLoading: ref.watch(
          prayerTimeViewModel.select((value) => value.initLoading.isLoading)),
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
                    ref.watch(prayerTimeViewModel
                            .select((value) => value.currentPrayer?.name)) ??
                        "-",
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
                          builder: (_) => const CityScreen(),
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
                                ref.watch(prayerTimeViewModel.select((value) =>
                                        value.prayerTime.value?.lokasi)) ??
                                    '-',
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
                    const _CountDown()
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: KSize.s16,
          ),
          () {
            final jadwal = ref.watch(prayerTimeViewModel
                .select((value) => value.prayerTime.value?.jadwal));

            return Row(
              children: [
                Text(
                  jadwal?.date.formatDateGeorgian() ?? '-',
                  style: KTextStyle.date,
                ),
                const Spacer(),
                Text(
                  jadwal?.date.formatDateHijri() ?? '-',
                  style: KTextStyle.date,
                ),
              ],
            );
          }(),
          const SizedBox(
            height: KSize.s16,
          ),
          const Divider(),
          const SizedBox(
            height: KSize.s16,
          ),
          ...(ref.watch(prayerTimeViewModel.select((value) => value
                      .prayerTime.value?.jadwal
                      ?.toListPrayerTimeDetail())) ??
                  [])
              .map(
            (e) => PrayerView(
              isActive: e.name ==
                  ref.watch(
                    prayerTimeViewModel.select(
                      (value) => value.nextPrayer?.name,
                    ),
                  ),
              prayer: e.name,
              time: e.time?.to24Format(),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountDown extends ConsumerStatefulWidget {
  const _CountDown();

  @override
  ConsumerState<_CountDown> createState() => _CountDownState();
}

class _CountDownState extends ConsumerState<_CountDown> {
  @override
  Widget build(BuildContext context) {
    return Text(
      () {
        final countDown = ref.watch(prayerTimeViewModel).countDown;
        return '- ${countDown.inHours}:${countDown.inMinutes % 60}:${countDown.inSeconds % 60}';
      }(),
      style: KTextStyle.date
          .copyWith(color: Theme.of(context).colorScheme.secondary),
    );
  }
}
