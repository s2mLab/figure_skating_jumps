import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

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
            padding: const EdgeInsets.only(top: 16.0),
            child: _athlete.uID == UserClient().currentSkatingUser!.uID!
                ? const Text(noOptionsAvailable)
                : IceButton(
                    text: removeThisAthlete,
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                                title: const Text(confirmAthleteRemoval),
                                actions: [
                                  IceButton(
                                      text: cancel,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      textColor: primaryColor,
                                      color: primaryColor,
                                      iceButtonImportance:
                                          IceButtonImportance.secondaryAction,
                                      iceButtonSize: IceButtonSize.small),
                                  IceButton(
                                      text: confirmText,
                                      onPressed: () async {
                                        await UserClient().unlinkSkaterAndCoach(
                                            skaterId: _athlete.uID!,
                                            coachId: UserClient()
                                                .currentSkatingUser!
                                                .uID!);
                                        UserClient()
                                            .currentSkatingUser!
                                            .trainees
                                            .removeWhere((element) =>
                                                element.uID == _athlete.uID!);
                                        UserClient()
                                            .currentSkatingUser!
                                            .traineesID
                                            .removeWhere((element) =>
                                                element == _athlete.uID!);
                                        if (context.mounted)
                                          Navigator.pushReplacementNamed(
                                              context, '/ListAthletes',
                                              arguments: true);
                                      },
                                      textColor: paleText,
                                      color: errorColorDark,
                                      iceButtonImportance:
                                          IceButtonImportance.mainAction,
                                      iceButtonSize: IceButtonSize.small)
                                ],
                                content: const InstructionPrompt(
                                    confirmDelete, errorColor));
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
