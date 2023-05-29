import 'package:flutter/material.dart';
import 'package:prayer_time_app/screens/qibla/views/smooth_compass_view.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SmoothCompassView(
        isQiblahCompass: true,
        compassBuilder: (context, snapshot, child) {
          return AnimatedRotation(
            duration: const Duration(milliseconds: 800),
            turns: snapshot?.data?.turns ?? 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedRotation(
                    duration: const Duration(milliseconds: 0),
                    turns: (snapshot?.data?.qiblahOffset ?? 0) / 360,
                    //Place your qiblah needle here
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: width > height ? height : width,
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
