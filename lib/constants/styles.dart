import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/reactive_layout_helper.dart';
import 'colors.dart';

BoxShadow connectionShadow = BoxShadow(
  color: Colors.black.withOpacity(0.2),
  spreadRadius: 2,
  blurRadius: 4,
  offset: const Offset(0, 4), // changes position of shadow
);


const double promptTextHeight = 1.1;
TextStyle tabStyle =
    const TextStyle(color: primaryColorDark, fontWeight: FontWeight.bold);

final TextStyle connectingStyle = TextStyle(color: darkText, fontSize: ReactiveLayoutHelper.isTablet() ? ReactiveLayoutHelper.getHeightFromFactor(16): 16);
final TextStyle connectedStyle = TextStyle(color: connectedXSensDotButtonForeground, fontSize: ReactiveLayoutHelper.isTablet() ? ReactiveLayoutHelper.getHeightFromFactor(16) : 16);

const dateFormatString = 'dd/MM/yyyy - hh:mm:ss';
final dateSecondsDisplayFormat = DateFormat(dateFormatString);