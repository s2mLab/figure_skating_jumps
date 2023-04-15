import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/services/graph_date_preferences_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateFilterDialogContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

}

class _DateFilterDialogContentState extends State<DateFilterDialogContent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IceButton(text: "Date de début", onPressed: () {
          showDatePicker(context: context, initialDate: GraphDatePreferencesService.begin, firstDate: DateTime(2023), lastDate: GraphDatePreferencesService.end).then((value) {
            if(value==null) return;
            if(value.isAfter(GraphDatePreferencesService.end)){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(notAfterInfo)));
            }
            setState(() {
              GraphDatePreferencesService.begin = value;
            });
            Navigator.pop(context);
          });
        }, textColor: primaryColor, color: primaryColor, iceButtonImportance: IceButtonImportance.secondaryAction, iceButtonSize: IceButtonSize.medium),
        IceButton(text: "Date de fin", onPressed: () {
          showDatePicker(context: context, initialDate: GraphDatePreferencesService.end, firstDate: GraphDatePreferencesService.begin, lastDate: DateTime.now()).then((value) {
            if(value==null) return;
            if(value.isBefore(GraphDatePreferencesService.begin)){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(notBeforeInfo)));
            }
            setState(() {
              GraphDatePreferencesService.end = value;
            });
            Navigator.pop(context);
          });
        }, textColor: primaryColor, color: primaryColor, iceButtonImportance: IceButtonImportance.secondaryAction, iceButtonSize: IceButtonSize.medium),
      ],
    );

  }

}