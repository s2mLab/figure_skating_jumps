import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../enums/ice_button_size.dart';
import '../../models/capture.dart';
import '../../models/jump.dart';
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
  List<bool> _isPanelsOpen = [];
  late ScrollController _jumpListScrollController;
  bool _timeWasModified = false;

  @override
  void initState() {
    _jumpListScrollController = ScrollController();
    super.initState();
  }

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
                    if (_capture!.hasVideo)
                      IceButton(
                          text: seeVideoAgain,
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
                  child: InstructionPrompt(analysisDonePrompt, secondaryColor),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: const LegendMove()),
                CaptureListTile(currentCapture: _capture, isInteractive: false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PageTitle(text: detectedJumps),
                    IceButton(
                        text: addAJump,
                        onPressed: () async {
                          Jump newJump = Jump(0, 0, true, JumpType.unknown, "",
                              0, _capture!.uID!, 0, 0, 0);
                          setState(() {
                            _capture!.jumps.insert(0, newJump);
                          });
                          _jumpListScrollController.animateTo(0,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.ease);
                          await CaptureClient()
                              .createJump(jump: newJump)
                              .then((value) {
                            Navigator.pushReplacementNamed(
                                context, '/EditAnalysis',
                                arguments: _capture);
                          });
                        },
                        textColor: primaryColor,
                        color: primaryColor,
                        iceButtonImportance:
                            IceButtonImportance.secondaryAction,
                        iceButtonSize: IceButtonSize.small)
                  ],
                ),
                if (_timeWasModified)
                  Center(
                      child: IceButton(
                          text: reorderJumpList,
                          onPressed: () {
                            Capture.sortJumps(_capture!);
                            Navigator.pushReplacementNamed(
                                context, '/EditAnalysis',
                                arguments: _capture);
                          },
                          textColor: secondaryColor,
                          color: secondaryColor,
                          iceButtonImportance:
                              IceButtonImportance.discreetAction,
                          iceButtonSize: IceButtonSize.small)),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _jumpListScrollController,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ExpansionPanelList(
                        expandedHeaderPadding: EdgeInsets.zero,
                        expansionCallback: (i, isOpen) {
                          setState(() {
                            _isPanelsOpen[i] = !isOpen;
                          });
                        },
                        elevation: 0,
                        children:
                            List.generate(_capture!.jumps.length, (index) {
                          _isPanelsOpen.add(false);
                          return ExpansionPanel(
                              canTapOnHeader: true,
                              backgroundColor: Colors.transparent,
                              isExpanded: _isPanelsOpen[index],
                              headerBuilder:
                                  (BuildContext context, bool isExpanded) {
                                return JumpPanelHeader(
                                    jump: _capture!.jumps[index]);
                              },
                              body: JumpPanelContent(
                                  jump: _capture!.jumps[index],
                                  onModified: (Jump j, JumpType initialJumpType,
                                      int initialTime) {
                                    if (j.time != initialTime) {
                                      _timeWasModified = true;
                                    }
                                    setState(() {
                                      _capture!.jumpTypeCount[initialJumpType] =
                                          _capture!.jumpTypeCount[
                                                  initialJumpType]! -
                                              1;
                                      _capture!.jumpTypeCount[j.type] =
                                          _capture!.jumpTypeCount[j.type]! + 1;
                                      CaptureClient().updateJump(jump: j);
                                    });
                                  },
                                  onDeleted: (Jump j, JumpType initial) {
                                    setState(() {
                                      _capture!.jumpTypeCount[initial] =
                                          _capture!.jumpTypeCount[initial]! - 1;
                                      _capture!.jumps.remove(j);
                                      _capture = _capture;
                                      _isPanelsOpen = [];
                                    });
                                    CaptureClient()
                                        .deleteJump(jump: j)
                                        .then((value) {
                                      Navigator.pushReplacementNamed(
                                          context, '/EditAnalysis',
                                          arguments: _capture);
                                    }); //no need to await, done in the background
                                  }));
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
