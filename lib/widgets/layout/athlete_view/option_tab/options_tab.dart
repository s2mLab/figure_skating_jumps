import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/lang_fr.dart';
import '../../../../enums/ice_button_size.dart';
import '../../../../models/skating_user.dart';

class OptionsTab extends StatelessWidget {
  final SkatingUser _athlete;
  const OptionsTab({required SkatingUser athlete, Key? key})
      : _athlete = athlete,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: ReactiveLayoutHelper.getHeightFromFactor(16)),
            child: _athlete.uID == UserClient().currentSkatingUser!.uID!
                ? Text(
                    noOptionsAvailableInfo,
                    style: TextStyle(
                        fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
                  )
                : IceButton(
                    text: removeThisAthleteButton,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                                title: Text(confirmAthleteRemovalButton,
                                    style: TextStyle(
                                        fontSize: ReactiveLayoutHelper
                                            .getHeightFromFactor(16))),
                                actions: [
                                  IceButton(
                                      text: cancelLabel,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      textColor: primaryColor,
                                      color: primaryColor,
                                      iceButtonImportance:
                                          IceButtonImportance.secondaryAction,
                                      iceButtonSize: IceButtonSize.small),
                                  IceButton(
                                      text: confirmLabel,
                                      onPressed: () async {
                                        await UserClient().unlinkSkaterAndCoach(
                                            skaterId: _athlete.uID!,
                                            coachId: UserClient()
                                                .currentSkatingUser!
                                                .uID!);
                                        UserClient()
                                            .currentSkatingUser!
                                            .traineesID
                                            .removeWhere((element) =>
                                                element == _athlete.uID!);
                                        if (context.mounted) {
                                          Navigator.pushReplacementNamed(
                                              context, '/ListAthletes',
                                              arguments: true);
                                        }
                                      },
                                      textColor: paleText,
                                      color: errorColorDark,
                                      iceButtonImportance:
                                          IceButtonImportance.mainAction,
                                      iceButtonSize: IceButtonSize.small)
                                ],
                                content: const InstructionPrompt(
                                    confirmDeleteInfo, errorColor));

                          });
                    },
                    textColor: primaryColor,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.discreetAction,
                    iceButtonSize: IceButtonSize.medium),
          )
        ],
      ),
    );
  }
}
