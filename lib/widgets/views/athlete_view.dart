import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/models/firebase/capture.dart';
import 'package:figure_skating_jumps/models/firebase/skating_user.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/services/firebase/capture_client.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/layout/athlete_view/captures_tab/captures_tab.dart';
import 'package:figure_skating_jumps/widgets/layout/athlete_view/option_tab/options_tab.dart';
import 'package:figure_skating_jumps/widgets/layout/athlete_view/progression_tab/progression_tab.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/tablet_topbar.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';

class CapturesView extends StatefulWidget {
  const CapturesView({Key? key}) : super(key: key);

  @override
  State<CapturesView> createState() {
    return _CapturesViewState();
  }
}

class _CapturesViewState extends State<CapturesView> {
  int _switcherIndex = 0;
  SkatingUser? skater;
  Future<List<Capture>>? _futureCaptures;

  @override
  Widget build(BuildContext context) {
    ReactiveLayoutHelper.updateDimensions(context);
    skater ??= ModalRoute.of(context)!.settings.arguments as SkatingUser;
    _futureCaptures ??= skater?.getCapturesData();
    return Scaffold(
      appBar: ReactiveLayoutHelper.isTablet()
          ? const TabletTopbar(isUserDebuggingFeature: false)
              as PreferredSizeWidget
          : const Topbar(isUserDebuggingFeature: false),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: ReactiveLayoutHelper.getWidthFromFactor(24, true),
                bottom: ReactiveLayoutHelper.getHeightFromFactor(16),
                top: ReactiveLayoutHelper.getHeightFromFactor(16)),
            child: PageTitle(text: '${skater!.firstName} ${skater!.lastName}'),
          ),
          Center(
              child: SlideSwitcher(
            onSelect: (int index) => setState(() => _switcherIndex = index),
            slidersColors: const [primaryBackground],
            containerHeight: ReactiveLayoutHelper.getHeightFromFactor(40),
            containerWight: ReactiveLayoutHelper.getWidthFromFactor(390),
            indents: 2,
            containerColor: primaryColorLight,
            children: [
              Text(capturesTab, style: tabStyle),
              Text(progressionTab, style: tabStyle),
              Text(optionsTab, style: tabStyle),
            ],
          )),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ReactiveLayoutHelper.isTablet()
                      ? ReactiveLayoutHelper.getWidthFromFactor(8, true)
                      : ReactiveLayoutHelper.getWidthFromFactor(8)),
              child: IndexedStack(
                index: _switcherIndex,
                children: [
                  FutureBuilder(
                    future: _futureCaptures,
                    builder: _buildCapturesTab,
                  ),
                  FutureBuilder(
                    future: _futureCaptures,
                    builder: _buildProgressionTab,
                  ),
                  OptionsTab(athlete: skater!),
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: ReactiveLayoutHelper.getHeightFromFactor(16),
                  top: ReactiveLayoutHelper.getHeightFromFactor(4)),
              child: IceButton(
                  elevation: 4.0,
                  text: captureButton,
                  onPressed: CameraService().hasCamera
                      ? () {
                          CaptureClient().capturingSkatingUser = skater!;
                          Navigator.pushNamed(context, '/CaptureData');
                        }
                      : null,
                  textColor: paleText,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.mainAction,
                  iceButtonSize: IceButtonSize.large),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the captures tab widget.
  ///
  /// If the snapshot's connection state is not [ConnectionState.done], this
  /// function will display a [CircularProgressIndicator] centered on the screen
  /// while the data is still loading.
  ///
  /// Parameters:
  /// - [context] : the build context
  /// - [snapshot] : the async snapshot of a list of captures
  ///
  /// Returns a [CapturesTab] widget displaying the grouped captures.
  Widget _buildCapturesTab(
      BuildContext context, AsyncSnapshot<List<Capture>> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return Center(
          child: Padding(
        padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(32)),
        child: const CircularProgressIndicator(),
      ));
    }
    snapshot.data!
        .sort((Capture left, Capture right) => right.date.compareTo(left.date));
    return CapturesTab(
        groupedCaptures: groupBy(
            snapshot.data!, (obj) => obj.date.toString().substring(0, 10)));
  }

  /// Builds the progression tab widget.
  ///
  /// If the snapshot's connection state is not [ConnectionState.done], this
  /// function will display a [CircularProgressIndicator] centered on the screen
  /// while the data is still loading.
  ///
  /// Parameters:
  /// - [context] : the build context
  /// - [snapshot] : the async snapshot of a list of captures
  ///
  /// Returns a [ProgressionTab] widget displaying the .
  Widget _buildProgressionTab(
      BuildContext context, AsyncSnapshot<List<Capture>> snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
      return Center(
          child: Padding(
        padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(32)),
        child: const CircularProgressIndicator(),
      ));
    }
    snapshot.data!
        .sort((Capture left, Capture right) => left.date.compareTo(right.date));
    return ProgressionTab(
        groupedCaptures: groupBy(
            snapshot.data!, (obj) => obj.date.toString().substring(0, 10)));
  }
}
