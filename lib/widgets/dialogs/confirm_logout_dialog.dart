import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/material.dart';

class ConfirmLogoutDialog extends StatelessWidget {
  const ConfirmLogoutDialog({super.key, required this.confirmAction});

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
        padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(8)),
              child: Text(
                disconnectLabel,
                style: TextStyle(
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(20)),
              ),
            ),
            Row(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: EdgeInsets.only(
                    right: ReactiveLayoutHelper.getWidthFromFactor(16)),
                child: IceButton(
                    text: goBackLabel,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: paleText,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.mainAction,
                    iceButtonSize: IceButtonSize.small),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ReactiveLayoutHelper.getWidthFromFactor(16)),
                child: IceButton(
                    text: continueDisconnectButton,
                    onPressed: () => confirmAction(),
                    textColor: errorColor,
                    color: errorColor,
                    iceButtonImportance: IceButtonImportance.secondaryAction,
                    iceButtonSize: IceButtonSize.small),
              )
            ])
          ],
        ),
      ),
    );
  }
}
