import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/services/graph_date_preferences_service.dart';
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
      dateDisplayFormat.format(GraphDatePreferencesService.begin);
  String displayedEnd =
      dateDisplayFormat.format(GraphDatePreferencesService.end);

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
                          initialDate: GraphDatePreferencesService.begin,
                          firstDate: DateTime(2023),
                          lastDate: GraphDatePreferencesService.end)
                      .then((value) {
                    if (value == null) return;
                    if (value.isAfter(GraphDatePreferencesService.end)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(notAfterInfo)));
                    }
                    setState(() {
                      GraphDatePreferencesService.begin = value;
                      displayedBegin = dateDisplayFormat
                          .format(GraphDatePreferencesService.begin);
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
                          initialDate: GraphDatePreferencesService.end,
                          firstDate: GraphDatePreferencesService.begin,
                          lastDate: DateTime.now())
                      .then((value) {
                    if (value == null) return;
                    if (value.isBefore(GraphDatePreferencesService.begin)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text(notBeforeInfo)));
                    }
                    setState(() {
                      GraphDatePreferencesService.end = value;
                      displayedEnd = dateDisplayFormat
                          .format(GraphDatePreferencesService.end);
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
              GraphDatePreferencesService.begin =
                  DateTime.now().subtract(const Duration(days: 7));
              GraphDatePreferencesService.end = DateTime.now();
              displayedBegin =
                  dateDisplayFormat.format(GraphDatePreferencesService.begin);
              displayedEnd =
                  dateDisplayFormat.format(GraphDatePreferencesService.end);
            });
            widget._setStateCallback();
          },
        ))
      ],
    );
  }
}
