import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
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
        insetPadding: EdgeInsets.symmetric(
            horizontal: ReactiveLayoutHelper.getWidthFromFactor(16)),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                description,
                style: TextStyle(
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(20)),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ReactiveLayoutHelper.getHeightFromFactor(16)),
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
