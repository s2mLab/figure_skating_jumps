import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/layout/capture_list_tile.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../enums/ice_button_size.dart';
import '../layout/legend_move.dart';
import '../layout/scaffold/ice_drawer_menu.dart';
import '../layout/scaffold/topbar.dart';

class EditAnalysisView extends StatelessWidget {
  const EditAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(isUserDebuggingFeature: false),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.transparent,
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PageTitle(text: "Analyse"),
                  if (true /*hasVideo*/)
                    IceButton(
                        text: "Revoir la vidéo",
                        onPressed: () {}, // TODO: video preview
                        textColor: primaryColor,
                        color: primaryColor,
                        iceButtonImportance: IceButtonImportance.secondaryAction,
                        iceButtonSize: IceButtonSize.small)
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: InstructionPrompt("L'analyse est terminée. Vous pouvez catégoriser les sauts et donner des rétroactions au besoin.", secondaryColor),
              ),
              Container(margin: const EdgeInsets.all(8), child: const LegendMove()),
              /*CaptureListTile(currentCapture: )),*/
            ],
          ),
        ));
  }
}
