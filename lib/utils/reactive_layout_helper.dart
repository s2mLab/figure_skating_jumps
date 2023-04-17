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

  /// Checks whether the current device is a tablet based on the screen width.
  ///
  /// Returns true if the screen width is greater than the _tabletWidthThreshold,
  static bool isTablet() {
    return _screenWidth > _tabletWidthThreshold;
  }

  /// Returns the height value from a factor calculated with the screen height and an expected height.
  ///
  /// Parameters:
  /// - [value]: The factor to calculate the height from.
  /// - [isEnglobingPadding] (optional): If true, adds an extra vertical padding to the height on tablet devices.
  ///
  /// Returns: A double value representing the calculated height.
  static double getHeightFromFactor(double value,
      [bool isEnglobingPadding = false]) {
    return value * _screenHeight / _expectedHeight +
        (isEnglobingPadding && isTablet() ? extraEnglobingVerticalPadding : 0);
  }

  /// Returns the width value, given a factor value, in the current screen size, adjusted to the expectedWidth value,
  /// optionally accounting for englobing padding (if isEnglobingPadding is true) in case the screen is a tablet.
  ///
  /// Parameters:
  /// - [value]: The factor value to calculate the width from.
  /// - [isEnglobingPadding] (optional): Indicates whether to account for englobing padding in case of tablet screen.
  ///
  /// Returns: The calculated width value.
  static double getWidthFromFactor(double value,
      [bool isEnglobingPadding = false]) {
    return value * _screenWidth / _expectedWidth +
        (isEnglobingPadding && isTablet()
            ? extraEnglobingHorizontalPadding
            : 0);
  }

  /// This method updates the dimensions of the screen, including the width and height,
  /// by taking a [BuildContext] as input and retrieving the screen size through
  /// [MediaQuery.of(context)]. The values are then stored in static variables [_screenHeight]
  /// and [_screenWidth] for later use.
  ///
  /// Parameters:
  /// - [context]: The build context of the widget being built.
  static void updateDimensions(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
  }

  /// Calculates the scaling factor to fit a camera preview with the given dimensions
  /// into the current screen dimensions. This method takes into account whether the device is a tablet
  /// or not, in which case a different factor is used to account for the larger screen size.
  ///
  /// Parameters:
  /// - [width]: The width of the camera preview.
  /// - [height]: The height of the camera preview.
  ///
  /// Return: A scaling factor that can be used to adjust the size of the camera preview to fit the screen.
  static double getCameraScalingFactor(
      {required double width, required double height}) {
    double widthFactor = width / _screenWidth;
    double heightFactor = height / _screenHeight;
    return min(widthFactor, heightFactor) * (isTablet() ? 3.2 : 2.5);
  }
}
