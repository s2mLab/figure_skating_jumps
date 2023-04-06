import 'package:flutter/material.dart';

class ReactiveLayoutHelper {
  static const double _expectedHeight = 890;
  static const double _expectedWidth = 411;
  static double _screenHeight = 0;
  static double _screenWidth = 0;

  static double getScreenHeight() {
   return _screenHeight;
 }
  static double getScreenWidth() {
    return _screenWidth;
  }

  static double getHeightFromFactor(double value) {
    return value * _screenHeight / _expectedHeight;
  }

  static double getWidthFromFactor(double value) {
    return value * _screenWidth / _expectedWidth;
  }

  static void updateDimensions(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    print('height:${_screenHeight}width:$_screenWidth');
  }
}