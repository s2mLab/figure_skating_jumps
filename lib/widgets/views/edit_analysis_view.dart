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
  List<Jump> _jumps = [];
  LocalCapture? _captureInfo;
  final List<bool> _isPanelsOpen = [];
  final Set<int> _misplacedJumpIndex = {};
  late Map<JumpType, int> _jumpTypeCount;
  late ScrollController _jumpListScrollController;

  @override
  void initState() {
    _jumpListScrollController = ScrollController();
    super.initState();
  }

  Future<void> _loadCaptureData() async {
    _capture ??= ModalRoute.of(context)!.settings.arguments as Capture;
    _captureInfo = await LocalCapturesManager().getCapture(_capture!.uID!);
    if (_capture!.jumpsID.length != _jumps.length) {
      _jumps.clear();
      _jumps = await _capture!.getJumpsData();
      _jumpTypeCount = Capture.getJumpTypeCount(_jumps);
    }
    _jumps.sort((a, b) => a.time.compareTo(b.time));
  }

  bool _jumpsNeedsReorder(int initialTime, int index) {
    return _jumps[index].time != initialTime && !_isJumpWellPlaced(index);
  }

  bool _isJumpWellPlaced(int index) {
    return (index == 0 || _jumps[index - 1].time <= _jumps[index].time) &&
        (index == _jumps.length - 1 || _jumps[index + 1].time >= _jumps[index].time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ReactiveLayoutHelper.isTablet()
            ? const TabletTopbar(isUserDebuggingFeature: false)
                as PreferredSizeWidget
            : const Topbar(isUserDebuggingFeature: false),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.transparent,
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: _capture == null
            ? FutureBuilder(
                future: _loadCaptureData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return _editAnalysisViewStaticContent();
                },
              )
            : _editAnalysisViewStaticContent());
  }

  Widget _editAnalysisViewStaticContent() {
    return SizedBox(
      height: MediaQuery.of(context).size.height -
          (ReactiveLayoutHelper.isTablet() ? bigTopbarHeight : topbarHeight),
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
                      iceButtonImportance: IceButtonImportance.secondaryAction,
                      iceButtonSize: IceButtonSize.small)
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: ReactiveLayoutHelper.getHeightFromFactor(24)),
              child: const InstructionPrompt(analysisDoneInfo, secondaryColor),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                child: const LegendMove()),
            CaptureListTile(
                currentCapture: _capture!, isInteractive: false, jumps: _jumps),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const PageTitle(text: detectedJumpsTitle),
                IceButton(
                    text: addAJumpButton,
                    onPressed: () async {
                      Jump newJump = Jump(0, 0, true, JumpType.unknown, "", 0,
                          _capture!.uID!, 0, 0, 0);
                      newJump = await CaptureClient().createJump(jump: newJump);
                      _capture!.jumpsID.add(newJump.uID!);
                      if (mounted) {
                        Navigator.pushReplacementNamed(context, '/EditAnalysis',
                            arguments: _capture);
                      }
                    },
                    textColor: primaryColor,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.secondaryAction,
                    iceButtonSize: IceButtonSize.small)
              ],
            ),
            if (_misplacedJumpIndex.isNotEmpty && _jumps.length > 1)
              Center(
                  child: IceButton(
                      text: reorderJumpListButton,
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/EditAnalysis',
                            arguments: _capture);
                      },
                      textColor: secondaryColor,
                      color: secondaryColor,
                      iceButtonImportance: IceButtonImportance.discreetAction,
                      iceButtonSize: IceButtonSize.small)),
            Expanded(
              child: SingleChildScrollView(
                controller: _jumpListScrollController,
                child: _jumps.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                            top: ReactiveLayoutHelper.getHeightFromFactor(8)),
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
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return JumpPanelHeader(jump: _jumps[index]);
                                },
                                body: JumpPanelContent(
                                  onChangeAllTypes: (JumpType jumpType) async {
                                    for(Jump j in _jumps){
                                      j.type = jumpType;
                                      await CaptureClient().updateJump(jump: j);
                                    }
                                    setState(() {
                                    });
                                    if (mounted) {
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
                                    }

                                  },
                                    jump: _jumps[index],
                                    onModified: (Jump j,
                                        JumpType initialJumpType,
                                        int initialTime) {
                                      _misplacedJumpIndex.remove(index);
                                      List<int> reorderedJumpsAfterMod = [];
                                      for (int i in _misplacedJumpIndex) {
                                        if (_isJumpWellPlaced(i)) {
                                          reorderedJumpsAfterMod.add(i);
                                        }
                                      }
                                      _misplacedJumpIndex.removeAll(reorderedJumpsAfterMod);
                                      if (_jumpsNeedsReorder(initialTime, index)) {
                                        _misplacedJumpIndex.add(index);
                                      }
                                      setState(() {
                                        _jumpTypeCount[initialJumpType] =
                                            _jumpTypeCount[initialJumpType]! -
                                                1;
                                        _jumpTypeCount[j.type] =
                                            _jumpTypeCount[j.type]! + 1;
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
                                    onDeleted:
                                        (Jump j, JumpType initial) async {
                                      _capture!.jumpsID.removeWhere(
                                          (element) => element == j.uID!);
                                      // _jumps.removeWhere((element) => element.uID! == j.uID!);
                                      await CaptureClient().deleteJump(jump: j);
                                      if (mounted) {
                                        Navigator.pushReplacementNamed(
                                            context, '/EditAnalysis',
                                            arguments: _capture);
                                      }
                                    }));
                          }),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
