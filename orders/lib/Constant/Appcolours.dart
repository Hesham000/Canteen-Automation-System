import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color startColor = Color(0xFFF5AF19);
  static const Color endColor = Color(0xFFF12711);

  static const LinearGradient flareGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [startColor, endColor],
  );
}
