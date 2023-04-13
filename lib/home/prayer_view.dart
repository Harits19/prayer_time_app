import 'package:flutter/material.dart';
import 'package:prayer_time_app/constans/k_size.dart';

class PrayerView extends StatelessWidget {
  const PrayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: KSize.s16),
      child: Padding(
        padding: const EdgeInsets.all(KSize.s16),
        child: Row(
          children: const [
            Expanded(
              child: Text('Shubuh'),
            ),
            Expanded(
              child: Text(
                '04:29',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
