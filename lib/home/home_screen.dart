import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/constans/k_text_style.dart';
import 'package:prayer_time_app/extensions/string_extension.dart';
import 'package:prayer_time_app/home/prayer_view.dart';
import 'package:prayer_time_app/main.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final prayerState = ref.watch(prayerTimeState);
    final prayerTime = prayerState?.jadwal;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(KSize.s16),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      const Text(
                        'Sekarang waktu',
                        style: TextStyle(
                          fontSize: KSize.s12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        'Ashar',
                        style: TextStyle(
                          fontSize: KSize.s32,
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: KSize.s12,
                            ),
                            const SizedBox(
                              width: KSize.s4,
                            ),
                            Text(
                              prayerState?.lokasi.toCapitalize() ?? '-',
                              style: const TextStyle(
                                fontSize: KSize.s12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: KSize.s4,
                        ),
                        Text(
                          'Magrib -02:04:27',
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
                    prayerTime?.date.formatDate() ?? '-',
                    style: KTextStyle.date,
                  ),
                  const Spacer(),
                  const Text(
                    '22 Ramadhan 1444 H',
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
              ...{
                'Imsak': prayerTime?.imsak,
                'Shubuh': prayerTime?.subuh,
                'Terbit': prayerTime?.terbit,
                'Dhuha': prayerTime?.dhuha,
                'Dzuhur': prayerTime?.dzuhur,
                'Ashar': prayerTime?.ashar,
                'Magrib': prayerTime?.maghrib,
                'Isya': prayerTime?.isya,
              }.entries.map(
                    (e) => PrayerView(
                      prayer: e.key,
                      time: e.value,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
