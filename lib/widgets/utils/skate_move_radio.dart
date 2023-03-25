//Inspired by : https://api.flutter.dev/flutter/material/RadioListTile-class.html

import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:flutter/material.dart';

class SkateMoveRadio extends StatelessWidget {
  const SkateMoveRadio({
    super.key,
    required groupValue,
    required value,
    required onChanged,
  }):
  _groupValue = groupValue,
  _value = value,
  _onChanged = onChanged;

  final JumpType _groupValue;
  final JumpType _value;
  final ValueChanged<JumpType> _onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_value != _groupValue) {
          _onChanged(_value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: <Widget>[
            Radio<JumpType>(
              groupValue: _groupValue,
              value: _value,
              onChanged: (JumpType? newValue) {
                _onChanged(newValue!);
              },
            ),
            Text(_value.abbreviation, style: TextStyle(color: _value.color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}