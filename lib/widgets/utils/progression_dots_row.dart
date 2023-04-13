import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:flutter/material.dart';

class ProgressionDotsRow extends StatelessWidget {
  final int _steps;
  final int _state;
  final List<Widget> _stepWidgetList = [];
  ProgressionDotsRow({required int steps, required int state, super.key})
      : _state = state,
        _steps = steps {
    if (_steps < _state) {
      throw ArgumentError('State can\'t be higher than available steps');
    }
    if (_state <= 0 || _steps <= 0) {
      throw ArgumentError('State or steps can\'t be 0 or less');
    }
    _populateStepWidgetList();
  }

  void _populateStepWidgetList() {
    for (int index = 0; index < _steps; index++) {
      _stepWidgetList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  color: _state == index + 1
                      ? progressionBackgroundCurrent
                      : (_state < index + 1
                          ? progressionBackgroundNext
                          : primaryColorLight),
                  borderRadius: BorderRadius.circular(16))),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _stepWidgetList,
    );
  }
}
