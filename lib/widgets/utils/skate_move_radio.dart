//Inspired by : https://api.flutter.dev/flutter/material/RadioListTile-class.html

import 'package:figure_skating_jumps/enums/models/jump_type.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:flutter/material.dart';

class SkateMoveRadio extends StatelessWidget {
  const SkateMoveRadio({
    super.key,
    required groupValue,
    required value,
    required onChanged,
    required onLongPressChanged
  }):
  _groupValue = groupValue,
  _value = value,
  _onLongPressChanged = onLongPressChanged,
  _onChanged = onChanged;

  final JumpType _groupValue;
  final JumpType _value;
  final ValueChanged<JumpType> _onChanged;
  final ValueChanged<JumpType> _onLongPressChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_value != _groupValue) {
          _onChanged(_value);
        }
      },
      onLongPress: () {
        _onLongPressChanged(_value);
      },
      child: Column(
        children: <Widget>[
          Radio<JumpType>(
            activeColor: _value.color,
            groupValue: _groupValue,
            value: _value,
            onChanged: (JumpType? newValue) {
              _onChanged(newValue!);
            },
          ),
          Text(_value.abbreviation, style: TextStyle(color: _value.color, fontSize: ReactiveLayoutHelper.getHeightFromFactor(16), fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}