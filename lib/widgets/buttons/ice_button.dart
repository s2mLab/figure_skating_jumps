import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../enums/ice_button_importance.dart';

class IceButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IceButtonSize iceButtonSize;
  final IceButtonImportance iceButtonImportance;
  final Color textColor;
  final Color color;
  final String text;
  static const List<double> _heights = [24, 40, 56];
  static const List<double> _widths = [140, 240, 340];
  static const List<double> _textSizes = [12, 16, 18];

  const IceButton(
      {required this.text,
      required this.onPressed,
      required this.textColor,
      required this.color,
      required this.iceButtonImportance,
      required this.iceButtonSize,
      super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: iceButtonImportance == IceButtonImportance.mainAction
          ? color
          : primaryBackground,
      textColor: textColor,
      elevation: 0,
      focusElevation:
          iceButtonImportance == IceButtonImportance.discreetAction ? 0 : null,
      hoverElevation:
          iceButtonImportance == IceButtonImportance.discreetAction ? 0 : null,
      highlightElevation:
          iceButtonImportance == IceButtonImportance.discreetAction ? 0 : null,
      height: _heights[iceButtonSize.index],
      minWidth: iceButtonImportance == IceButtonImportance.discreetAction
          ? null
          : _widths[iceButtonSize.index],
      shape: iceButtonImportance == IceButtonImportance.secondaryAction
          ? RoundedRectangleBorder(
              side: BorderSide(width: 1, color: color),
              borderRadius: BorderRadius.circular(32))
          : (iceButtonImportance == IceButtonImportance.discreetAction
              ? null
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: _textSizes[iceButtonSize.index]),
      ),
    );
  }
}
