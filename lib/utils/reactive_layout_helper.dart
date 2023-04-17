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

  /// Retrieves the current screen height in logical pixels.
  ///
  /// Returns a [double] value representing the current screen height.
  static double getScreenHeight() {
    return _screenHeight;
  }

  /// Retrieves the current screen width in logical pixels.
  ///
  /// Returns a [double] value representing the current screen width.
  static double getScreenWidth() {
    return _screenWidth;
  }

// Checks whether the current device is a tablet based on the screen width.
  ///
  /// Returns true if the screen width is greater than the _tabletWidthThreshold,
  static bool isTablet() {
    return _screenWidth > _tabletWidthThreshold;
  }

  /// Calculates and returns the height of a UI element based on a given factor value and an optional flag for padding.
  ///
  /// This function takes a [double] value representing the factor by which to scale the element's height, as well as an
  /// optional [bool] flag to indicate whether the element should include padding for enclosing elements. If the flag is
  /// set to true and the device is a tablet, the function adds an extra amount of vertical padding.
  ///
  /// Returns a [double] value representing the calculated height of the UI element.
  static double getHeightFromFactor(double value,
      [bool isEnglobingPadding = false]) {
    return value * _screenHeight / _expectedHeight +
        (isEnglobingPadding && isTablet() ? extraEnglobingVerticalPadding : 0);
  }

  /// Calculates and returns the width of a UI element based on a given factor value and an optional flag for padding.
  ///
  /// This function takes a [double] value representing the factor by which to scale the element's width, as well as an
  /// optional [bool] flag to indicate whether the element should include padding for enclosing elements. If the flag is
  /// set to true and the device is a tablet, the function adds an extra amount of horizontal padding.
  ///
  /// Returns a [double] value representing the calculated width of the UI element.
  static double getWidthFromFactor(double value,
      [bool isEnglobingPadding = false]) {
    return value * _screenWidth / _expectedWidth +
        (isEnglobingPadding && isTablet()
            ? extraEnglobingHorizontalPadding
            : 0);
  }

  /// Updates the stored dimensions of the device screen based on the provided [BuildContext].
  ///
  /// This function takes a [BuildContext] value and uses it to retrieve the height and width of the device screen
  /// using the `MediaQuery` API. It then updates the stored `_screenHeight` and `_screenWidth` values to reflect
  /// the new dimensions.
  static void updateDimensions(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
  }

  /// Computes and returns the camera scaling factor for the device screen based on the provided width and height values.
  ///
  /// This function takes a `width` and a `height` value and computes the scaling factor required to ensure that
  /// the camera view fits within the bounds of the screen. It computes separate scaling factors for the width and height,
  /// and returns the minimum of the two values multiplied by a device-specific scaling factor.
  ///
  /// Returns a [double] value representing the camera scaling factor.
  static double getCameraScalingFactor(
      {required double width, required double height}) {
    double widthFactor = width / _screenWidth;
    double heightFactor = height / _screenHeight;
    return min(widthFactor, heightFactor) * (isTablet() ? 3.2 : 2.5);
  }
}
