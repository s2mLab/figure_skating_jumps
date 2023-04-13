import 'dart:math';

import 'package:flutter/material.dart';

class ReactiveLayoutHelper {
  static const double _expectedHeight = 890;
  static const double _expectedWidth = 411;
  static const double extraEnglobingHorizontalPadding = 48;
  static const double extraEnglobingVerticalPadding = 32;
  static double _screenHeight = 0;
  static const double _tabletWidthThreshold = 600;
  static double _screenWidth = 0;

  static double getScreenHeight() {
    return _screenHeight;
  }

  static double getScreenWidth() {
    return _screenWidth;
  }

  static bool isTablet() {
    return _screenWidth > _tabletWidthThreshold;
  }

  static double getHeightFromFactor(double value,
      [bool isEnglobingPadding = false]) {
    return value * _screenHeight / _expectedHeight +
        (isEnglobingPadding && isTablet() ? extraEnglobingVerticalPadding : 0);
  }

  static double getWidthFromFactor(double value,
      [bool isEnglobingPadding = false]) {
    return value * _screenWidth / _expectedWidth +
        (isEnglobingPadding && isTablet() ? extraEnglobingHorizontalPadding : 0);
  }

  static void updateDimensions(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
  }

  static double getCameraScalingFactor({required double width, required double height}) {
    double widthFactor = width/_screenWidth;
    double heightFactor = height/_screenHeight;
    return min(widthFactor, heightFactor) * (isTablet() ? 3.2 : 2.5);
  }
}
