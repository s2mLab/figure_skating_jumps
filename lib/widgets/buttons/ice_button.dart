import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:flutter/material.dart';

class IceButton extends StatelessWidget {
  final VoidCallback? _onPressed;
  final IceButtonSize _iceButtonSize;
  final IceButtonImportance _iceButtonImportance;
  final Color _textColor;
  final Color _color;
  final String _text;
  final double _elevation;
  static const List<double> _heights = [24, 40, 56];
  static const List<double> _widths = [140, 240, 340];
  static const List<double> _textSizes = [12, 16, 18];
  static const double _defaultElevation = 0;

  const IceButton(
      {required String text,
      required VoidCallback? onPressed,
      required Color textColor,
      required Color color,
      required IceButtonImportance iceButtonImportance,
      required IceButtonSize iceButtonSize,
      double elevation = _defaultElevation,
      super.key})
      : _text = text,
        _onPressed = onPressed,
        _textColor = textColor,
        _color = color,
        _iceButtonImportance = iceButtonImportance,
        _iceButtonSize = iceButtonSize,
        _elevation = elevation;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: _iceButtonImportance == IceButtonImportance.mainAction
          ? _color
          : primaryBackground,
      textColor: _textColor,
      elevation: _elevation,
      focusElevation:
          _iceButtonImportance == IceButtonImportance.discreetAction ? 0 : null,
      hoverElevation:
          _iceButtonImportance == IceButtonImportance.discreetAction ? 0 : null,
      highlightElevation:
          _iceButtonImportance == IceButtonImportance.discreetAction ? 0 : null,
      height: _heights[_iceButtonSize.index],
      minWidth: _iceButtonImportance == IceButtonImportance.discreetAction
          ? null
          : _widths[_iceButtonSize.index],
      shape: _iceButtonImportance == IceButtonImportance.secondaryAction
          ? RoundedRectangleBorder(
              side: BorderSide(width: 1, color: _color),
              borderRadius: BorderRadius.circular(32))
          : (_iceButtonImportance == IceButtonImportance.discreetAction
              ? null
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32))),
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: _textSizes[_iceButtonSize.index]),
      ),
    );
  }
}
