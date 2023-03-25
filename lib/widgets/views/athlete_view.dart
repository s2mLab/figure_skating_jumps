import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../layout/athlete_view/captures_tab/captures_tab.dart';
import '../layout/athlete_view/progression_tab/progression_tab.dart';
import '../layout/options_tab.dart';
import '../layout/scaffold/ice_drawer_menu.dart';
import '../layout/scaffold/topbar.dart';

class AthleteView extends StatefulWidget {
  const AthleteView({Key? key}) : super(key: key);

  @override
  State<AthleteView> createState() {
    return _AthleteViewState();
  }
}

class _AthleteViewState extends State<AthleteView> {
  int _switcherIndex = 0;
  SkatingUser? skater;
  Future<void>? _futureCaptures;

  @override
  Widget build(BuildContext context) {
    skater ??= ModalRoute.of(context)!.settings.arguments as SkatingUser;
    _futureCaptures ??= skater?.loadCapturesData(); //TODO load before

    return Scaffold(
      appBar: const Topbar(isUserDebuggingFeature: false),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child:
                  PageTitle(text: '${skater!.firstName} ${skater!.lastName}')),
          Center(
              child: SlideSwitcher(
            onSelect: (int index) => setState(() => _switcherIndex = index),
            slidersColors: const [primaryBackground],
            containerHeight: 40,
            containerWight: 390,
            indents: 2,
            containerColor: primaryColorLight,
            children: [
              Text(capturesTab, style: tabStyle),
              Text(progressionTab, style: tabStyle),
              Text(optionsTab, style: tabStyle),
            ],
          )),
          Expanded(
            child: IndexedStack(
              index: _switcherIndex,
              children: [
                FutureBuilder(
                  future: _futureCaptures,
                  builder: _buildCapturesTab,
                ),
                ProgressionTab(),
                const OptionsTab(),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: IceButton(
                  text: captureButton,
                  onPressed: () {
                    CaptureClient().capturingSkatingUser = skater!;
                    Navigator.pushNamed(
                      context,
                      '/CaptureData',
                    );
                  },
                  textColor: paleText,
                  color: secondaryColor,
                  iceButtonImportance: IceButtonImportance.mainAction,
                  iceButtonSize: IceButtonSize.large),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapturesTab(BuildContext context,
      AsyncSnapshot<void> snapshot) {
    return snapshot.connectionState == ConnectionState.done
        ? CapturesTab(captures: skater!.groupedCaptures)
        : const Center(
            child: Padding(
            padding: EdgeInsets.all(32.0),
            child: CircularProgressIndicator(),
          ));
  }
}
