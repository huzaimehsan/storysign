import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants/color_constants.dart';


Widget radialBackground({required Widget child}) {
  return Container(
    width: double.infinity,
    height: double.infinity, // full screen
    decoration: BoxDecoration(
      gradient: RadialGradient(
        colors: [
          midYellowColor,
          // center
          offWhiteColor,                // middle
          offWhiteColor.withOpacity(0.3), // soft transition
          pinkColor.withOpacity(0.2),  // outer edge
        ],
        stops: [
          0.5,  // center
          0.75,  // off-white start
          0.86,  // off-white fades into pink
          1.0,  // outer pink
        ],
        center: Alignment(-0.25, 0.09),
        radius: 0.9,
        focal: Alignment(0, -0.5),
        focalRadius: 0.05,
      ),
    ),
    child: child, // your content goes here
  );
}
