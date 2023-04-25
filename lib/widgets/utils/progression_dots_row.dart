import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:flutter/material.dart';

class ProgressionDotsRow extends StatelessWidget {
  final int _steps;
  final int _state;
  final List<Widget> _stepWidgetList = [];

  /// A widget that displays a row of dots indicating the progression of a process.
  ///
  /// Exceptions:
  /// - Throws an [ArgumentError] if the state is higher than the available steps.
  /// - Throws an [ArgumentError] if the state or the number of steps is 0 or less.
  ///
  /// Parameters:
  /// - [steps]: An [int] indicating the total number of steps in the process.
  /// - [state]: An [int] indicating the current step of the process.
  /// - [key]: An optional [Key] to use for the widget.
  ///
  /// Return: A [ProgressionDotsRow] widget.
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

  /// Populates the [_stepWidgetList] with the progress dots widgets for each step.
  /// The number of steps and the current state are given in the constructor of the widget.
  ///
  /// Exceptions:
  /// - [ArgumentError] if the state is higher than the available steps.
  /// - [ArgumentError] if the state or the steps are 0 or less.
  ///
  /// Parameters:
  /// - [super.key] (optional) : a key to use for the widget.
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
