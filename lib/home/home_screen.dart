import 'package:flutter/material.dart';
import 'package:prayer_time_app/constans/k_size.dart';
import 'package:prayer_time_app/constans/k_text_style.dart';
import 'package:prayer_time_app/home/prayer_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                          children: const [
                            Icon(
                              Icons.location_on,
                              size: KSize.s12,
                            ),
                            SizedBox(
                              width: KSize.s4,
                            ),
                            Text(
                              'Kota Jakarta',
                              style: TextStyle(
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
                children: const [
                  Text(
                    'Kamis, 13 April 2023',
                    style: KTextStyle.date,
                  ),
                  Spacer(),
                  Text(
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
              ...List.generate(
                8,
                (index) => const PrayerView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
