import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/ice_field_editable.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../layout/progression_dots_row.dart';

class CoachAccountCreationView extends StatefulWidget {
  const CoachAccountCreationView({super.key});

  @override
  State<CoachAccountCreationView> createState() =>
      _CoachAccountCreationViewState();
}

class _CoachAccountCreationViewState extends State<CoachAccountCreationView> {
  String _coachName = '';
  String _coachSurname = '';
  String _coachEmail = '';
  int _pageIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 72.0, horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 100,
                child: SvgPicture.asset(
                    'assets/vectors/blanc-logo-patinage-quebec.svg')),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryBackground,
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  boxShadow: [
                    // TODO: might want to save the boxshadow value in a style file for future use
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 12,
                              child: ProgressionDotsRow(steps: 2, state: 1)),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: PageTitle(text: coachCreateAccountTitle),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: InstructionPrompt(
                          ifNotAnAthletePrompt, secondaryColor),
                    ),
                    IceButton(
                        text: 'Poursuivre',
                        onPressed: () {},
                        textColor: paleText,
                        color: primaryColor,
                        iceButtonImportance: IceButtonImportance.mainAction,
                        iceButtonSize: IceButtonSize.medium),
                    IceButton(
                        text: 'J\'ai déjà un compte',
                        onPressed: () {},
                        textColor: primaryColor,
                        color: primaryColor,
                        iceButtonImportance:
                            IceButtonImportance.secondaryAction,
                        iceButtonSize: IceButtonSize.medium)
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  void toPassword() {
    setState(() {
      _pageIndex = 2;
    });
  }
}
