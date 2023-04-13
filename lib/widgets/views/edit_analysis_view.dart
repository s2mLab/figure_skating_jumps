import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/db_models/local_capture.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';
import 'package:figure_skating_jumps/services/manager/local_captures_manager.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/dialogs/video_player_dialog.dart';
import 'package:figure_skating_jumps/widgets/layout/capture_list_tile.dart';
import 'package:figure_skating_jumps/widgets/layout/edit_analysis_view/jump_panel_content.dart';
import 'package:figure_skating_jumps/widgets/layout/edit_analysis_view/jump_panel_header.dart';
import 'package:figure_skating_jumps/widgets/layout/legend_move.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/tablet_topbar.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

class EditAnalysisView extends StatefulWidget {
  const EditAnalysisView({super.key});
  @override
  State<EditAnalysisView> createState() => _EditAnalysisViewState();
}

class _EditAnalysisViewState extends State<EditAnalysisView> {
  Capture? _capture;
  final List<Jump> _jumps = [];
  LocalCapture? _captureInfo;
  List<bool> _isPanelsOpen = [];
  late ScrollController _jumpListScrollController;
  bool _timeWasModified = false;

  @override
  void initState() {
    _jumpListScrollController = ScrollController();
    super.initState();
  }

  Future<void> _loadVideoData() async {
    _capture ??= ModalRoute.of(context)!.settings.arguments as Capture;
    _captureInfo = await LocalCapturesManager().getCapture(_capture!.uID!);
    if (_capture!.jumpsID.length != _jumps.length) {
      _jumps.clear();
      for (String id in _capture!.jumpsID) {
        _jumps.add(await CaptureClient().getJumpByID(uID: id));
      }
    }
    _jumps.sort((a, b) => a.time.compareTo(b.time));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _loadVideoData();
    return Scaffold(
        appBar: ReactiveLayoutHelper.isTablet()
            ? const TabletTopbar(isUserDebuggingFeature: false)
                as PreferredSizeWidget
            : const Topbar(isUserDebuggingFeature: false),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.transparent,
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: SizedBox(
          height: MediaQuery.of(context).size.height -
              (ReactiveLayoutHelper.isTablet()
                  ? bigTopbarHeight
                  : topbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ReactiveLayoutHelper.isTablet()
                    ? ReactiveLayoutHelper.getWidthFromFactor(24, true)
                    : ReactiveLayoutHelper.getWidthFromFactor(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PageTitle(text: editAnalysisPageTitle),
                    if (_capture!.hasVideo &&
                        _captureInfo != null &&
                        _captureInfo!.videoPath.isNotEmpty)
                      IceButton(
                          text: seeVideoAgainButton,
                          onPressed: () {
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  return VideoPlayerDialog(
                                      videoPath: _captureInfo!.videoPath);
                                });
                          },
                          textColor: primaryColor,
                          color: primaryColor,
                          iceButtonImportance:
                              IceButtonImportance.secondaryAction,
                          iceButtonSize: IceButtonSize.small)
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: ReactiveLayoutHelper.getHeightFromFactor(24)),
                  child:
                      const InstructionPrompt(analysisDoneInfo, secondaryColor),
                ),
                Container(
                    margin: EdgeInsets.symmetric(
                        vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                    child: const LegendMove()),
                CaptureListTile(currentCapture: _capture, isInteractive: false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const PageTitle(text: detectedJumpsTitle),
                    IceButton(
                        text: addAJumpButton,
                        onPressed: () async {
                          Jump newJump = Jump(0, 0, true, JumpType.unknown, "",
                              0, _capture!.uID!, 0, 0, 0);
                          setState(() {
                            _jumps.insert(0, newJump);
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
                          text: reorderJumpListButton,
                          onPressed: () {
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
                    child: _jumps.isEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: ReactiveLayoutHelper.getHeightFromFactor(
                                    8)),
                            child: Center(
                                child: Text(noJumpInfo,
                                    style: TextStyle(
                                        fontSize: ReactiveLayoutHelper
                                            .getHeightFromFactor(16)))),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ExpansionPanelList(
                              expandedHeaderPadding: EdgeInsets.zero,
                              expansionCallback: (i, isOpen) {
                                setState(() {
                                  _isPanelsOpen[i] = !isOpen;
                                });
                              },
                              elevation: 0,
                              children: List.generate(_jumps.length, (index) {
                                _isPanelsOpen.add(false);
                                return ExpansionPanel(
                                    canTapOnHeader: true,
                                    backgroundColor: Colors.transparent,
                                    isExpanded: _isPanelsOpen[index],
                                    headerBuilder: (BuildContext context,
                                        bool isExpanded) {
                                      return JumpPanelHeader(
                                          jump: _jumps[index]);
                                    },
                                    body: JumpPanelContent(
                                        jump: _jumps[index],
                                        onModified: (Jump j,
                                            JumpType initialJumpType,
                                            int initialTime) {
                                          if (j.time != initialTime) {
                                            _timeWasModified = true;
                                          }
                                          setState(() {
                                            _capture!.jumpTypeCount[
                                                    initialJumpType] =
                                                _capture!.jumpTypeCount[
                                                        initialJumpType]! -
                                                    1;
                                            _capture!.jumpTypeCount[j.type] =
                                                _capture!.jumpTypeCount[
                                                        j.type]! +
                                                    1;
                                            CaptureClient()
                                                .updateJump(jump: j)
                                                .then((value) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      duration: const Duration(
                                                          seconds: 2),
                                                      backgroundColor: confirm,
                                                      content: Text(
                                                        savedModificationsSnackInfo,
                                                        style: TextStyle(
                                                            fontSize:
                                                                ReactiveLayoutHelper
                                                                    .getHeightFromFactor(
                                                                        16)),
                                                      )));
                                            });
                                          });
                                        },
                                        onDeleted: (Jump j, JumpType initial) {
                                          setState(() {
                                            _capture!.jumpTypeCount[initial] =
                                                _capture!.jumpTypeCount[
                                                        initial]! -
                                                    1;
                                            _jumps.remove(j);
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
