import 'package:flutter/material.dart';

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
