import 'package:flutter/material.dart';

class ColorCircle extends StatelessWidget {
  const ColorCircle({Key? key, required this.colorCircle}) : super(key: key);
  final Color colorCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
            color: colorCircle, borderRadius: BorderRadius.circular(10)));
  }
}
