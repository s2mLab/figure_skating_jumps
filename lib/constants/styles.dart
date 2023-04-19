import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/constants/colors.dart';

/// This file regroups styles and formats that are used more than once in the application.

BoxShadow connectionShadow = BoxShadow(
  color: Colors.black.withOpacity(0.2),
  spreadRadius: 2,
  blurRadius: 4,
  offset: const Offset(0, 4), // changes position of shadow
);

const double promptTextHeight = 1.1;
final TextStyle tabStyle = TextStyle(
    color: primaryColorDark,
    fontWeight: FontWeight.bold,
    fontSize: ReactiveLayoutHelper.getHeightFromFactor(16));

final TextStyle connectingStyle = TextStyle(
    color: darkText,
    fontSize: ReactiveLayoutHelper.isTablet()
        ? ReactiveLayoutHelper.getHeightFromFactor(14)
        : 14);
final TextStyle connectedStyle = TextStyle(
    color: connectedXSensDotButtonForeground,
    fontSize: ReactiveLayoutHelper.isTablet()
        ? ReactiveLayoutHelper.getHeightFromFactor(14)
        : 14);

const dateSecondsFormatString = 'dd/MM/yyyy - HH:mm:ss';
const dateFormatString = 'dd/MM/yyyy';
final dateSecondsDisplayFormat = DateFormat(dateSecondsFormatString);
final dateDisplayFormat = DateFormat(dateFormatString);
