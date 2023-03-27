import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';

class ConfirmCancelCustomDialog extends StatelessWidget {
  const ConfirmCancelCustomDialog(
      {required this.description, super.key, required this.confirmAction});

  final String description;
  final Function confirmAction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: primaryBackground,
        insetPadding: const EdgeInsets.only(left: 16, right: 16),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                description,
                style: const TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: IceButton(
                    text: confirmText,
                    onPressed: () => confirmAction(),
                    textColor: paleText,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.mainAction,
                    iceButtonSize: IceButtonSize.large),
              ),
              IceButton(
                  text: goBack,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: errorColor,
                  color: errorColor,
                  iceButtonImportance: IceButtonImportance.secondaryAction,
                  iceButtonSize: IceButtonSize.large)
            ],
          ),
        ));
  }
}
