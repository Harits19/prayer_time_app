import 'package:flutter/material.dart';
import 'package:prayer_time_app/constans/k_size.dart';

class PrayerView extends StatelessWidget {
  const PrayerView({
    super.key,
    this.prayer,
    this.time,
    this.isActive = false,
  });

  final String? prayer;
  final String? time;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isActive ? Theme.of(context).colorScheme.primary : null,
      margin: const EdgeInsets.only(bottom: KSize.s16),
      child: Padding(
        padding: const EdgeInsets.all(KSize.s16),
        child: Row(
          children: [
            Expanded(
              child: Text(prayer ?? '-'),
            ),
            Expanded(
              child: Text(
                time ?? '-',
                textAlign: TextAlign.right,
                style: const TextStyle(
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
