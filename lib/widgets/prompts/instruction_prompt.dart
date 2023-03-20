import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../constants/styles.dart';

class InstructionPrompt extends StatelessWidget {
  final String _text;
  final Color _color;
  const InstructionPrompt(this._text, this._color, {super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              height: double.infinity,
              width: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: _color,
              ),
            ),
          ),
          Expanded(
            child: Text(_text, style: const TextStyle(fontSize: 16, color: darkText, height: promptTextHeight), textAlign: TextAlign.left,
              softWrap: true),
          ),
        ]

      ),
    );
  }

}