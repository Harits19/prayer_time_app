import 'package:flutter/material.dart';
import 'package:smooth_compass/utils/src/compass_ui.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SmoothCompass(
        isQiblahCompass: true,
        compassBuilder: (context, snapshot, child) {
          return AnimatedRotation(
            duration: const Duration(milliseconds: 800),
            turns: snapshot?.data?.turns ?? 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Image.asset(
                //   "assets/compass.png",
                //   fit: BoxFit.fill,
                // ),
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   right: 0,
                //   bottom: 0,
                //   child: AnimatedRotation(
                //       duration: const Duration(milliseconds: 500),
                //       turns: (snapshot?.data?.qiblahOffset ?? 0) / 360,
                //       //Place your qiblah needle here
                //       child: Container(
                //         decoration: const BoxDecoration(
                //           shape: BoxShape.circle,
                //         ),
                //         child: const VerticalDivider(
                //           color: Colors.grey,
                //           thickness: 5,
                //         ),
                //       )),
                // ),

                AnimatedRotation(
                    duration: const Duration(milliseconds: 500),
                    turns: (snapshot?.data?.qiblahOffset ?? 0) / 360,
                    //Place your qiblah needle here
                    child: Icon(
                      Icons.keyboard_arrow_up_rounded,
                      size: MediaQuery.of(context).size.width,
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}
