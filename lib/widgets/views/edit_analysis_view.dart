import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../enums/ice_button_size.dart';
import '../../models/capture.dart';
import '../layout/capture_list_tile.dart';
import '../layout/edit_analysis_view/jump_panel_content.dart';
import '../layout/edit_analysis_view/jump_panel_header.dart';
import '../layout/legend_move.dart';
import '../layout/scaffold/ice_drawer_menu.dart';
import '../layout/scaffold/topbar.dart';

class EditAnalysisView extends StatefulWidget {
  const EditAnalysisView({super.key});
  @override
  State<EditAnalysisView> createState() => _EditAnalysisViewState();
}

class _EditAnalysisViewState extends State<EditAnalysisView> {
  Capture? _capture;
  final List<bool> _isPanelsOpen = [];

  @override
  Widget build(BuildContext context) {
    _capture ??= ModalRoute.of(context)!.settings.arguments as Capture;
    return Scaffold(
        appBar: const Topbar(isUserDebuggingFeature: false),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.transparent,
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: SizedBox(
          height: MediaQuery.of(context).size.height - topbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PageTitle(text: editAnalysisPageTitle),
                    if (true /*hasVideo*/)
                      IceButton(
                          text: "Revoir la vidéo",
                          onPressed: () {}, // TODO: video preview
                          textColor: primaryColor,
                          color: primaryColor,
                          iceButtonImportance:
                              IceButtonImportance.secondaryAction,
                          iceButtonSize: IceButtonSize.small)
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: InstructionPrompt(
                      analysisDonePrompt,
                      secondaryColor),
                ),
                Container(
                    margin: const EdgeInsets.all(8), child: const LegendMove()),
                CaptureListTile(currentCapture: _capture, isInteractive: false),
                const PageTitle(text: detectedJumps),
                Expanded(
                  child: SingleChildScrollView(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ExpansionPanelList(
                        expansionCallback: (i, isOpen) {
                          setState(() {
                            _isPanelsOpen[i] = !isOpen;
                          });
                        },
                        elevation: 0,
                        children: List.generate(_capture!.jumps.length*7, (index) {
                          _isPanelsOpen.add(false);
                          return ExpansionPanel(
                            backgroundColor: Colors.transparent,
                              isExpanded: _isPanelsOpen[index],
                              headerBuilder: (BuildContext context, bool isExpanded) {
                                return JumpPanelHeader(jump: _capture!.jumps[0]);
                              },
                              body: JumpPanelContent(
                                  jumpID: _capture!.jumps[0].uID!));
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
