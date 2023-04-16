import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/utils/graph_date_preferences_utils.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/material.dart';

class DateFilterDialogContent extends StatefulWidget {
  final VoidCallback _setStateCallback;
  const DateFilterDialogContent(
      {super.key, required void Function() setStateCallback})
      : _setStateCallback = setStateCallback;

  @override
  State<StatefulWidget> createState() => _DateFilterDialogContentState();
}

class _DateFilterDialogContentState extends State<DateFilterDialogContent> {
  String displayedBegin =
      dateDisplayFormat.format(GraphDatePreferencesUtils.begin);
  String displayedEnd =
      dateDisplayFormat.format(GraphDatePreferencesUtils.end);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IceButton(
                text: beginDateButton,
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: GraphDatePreferencesUtils.begin,
                          firstDate: DateTime(2023),
                          lastDate: GraphDatePreferencesUtils.end)
                      .then((value) {
                    if (value == null) return;
                    if (value.isAfter(GraphDatePreferencesUtils.end)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(notAfterInfo)));
                    }
                    setState(() {
                      GraphDatePreferencesUtils.begin = value;
                      displayedBegin = dateDisplayFormat
                          .format(GraphDatePreferencesUtils.begin);
                    });
                    widget._setStateCallback();
                  });
                },
                textColor: primaryColor,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.secondaryAction,
                iceButtonSize: IceButtonSize.small),
            Text(displayedBegin,
                style: TextStyle(
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(14))),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IceButton(
                text: endDateButton,
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: GraphDatePreferencesUtils.end,
                          firstDate: GraphDatePreferencesUtils.begin,
                          lastDate: DateTime.now())
                      .then((value) {
                    if (value == null) return;
                    if (value.isBefore(GraphDatePreferencesUtils.begin)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(notBeforeInfo)));
                    }
                    setState(() {
                      GraphDatePreferencesUtils.end = value;
                      displayedEnd = dateDisplayFormat
                          .format(GraphDatePreferencesUtils.end);
                    });
                    widget._setStateCallback();
                  });
                },
                textColor: primaryColor,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.secondaryAction,
                iceButtonSize: IceButtonSize.small),
            Text(displayedEnd,
                style: TextStyle(
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(14))),
          ],
        ),
        Center(
            child: IconButton(
          icon: Icon(Icons.restart_alt_outlined, size: ReactiveLayoutHelper.getHeightFromFactor(24),),
          onPressed: () {
            setState(() {
              GraphDatePreferencesUtils.begin =
                  DateTime.now().subtract(const Duration(days: 7));
              GraphDatePreferencesUtils.end = DateTime.now();
              displayedBegin =
                  dateDisplayFormat.format(GraphDatePreferencesUtils.begin);
              displayedEnd =
                  dateDisplayFormat.format(GraphDatePreferencesUtils.end);
            });
            widget._setStateCallback();
          },
        ))
      ],
    );
  }
}
