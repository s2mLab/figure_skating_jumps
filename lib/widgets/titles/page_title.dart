import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class PageTitle extends StatelessWidget {
  final String text;
  const PageTitle({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: primaryColor,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            fontFamily:
                'Jost')); // Haved to specify it here for some reason even if the theme is properly configured
  }
}
