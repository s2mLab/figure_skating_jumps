import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/widgets/layout/progression_tab.dart';
import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';
import '../../constants/colors.dart';
import '../layout/captures_tab.dart';
import '../layout/ice_drawer_menu.dart';
import '../layout/options_tab.dart';
import '../layout/topbar.dart';

class AcquisitionsView extends StatefulWidget {
  const AcquisitionsView({Key? key}) : super(key: key);

  @override
  _AcquisitionsViewState createState() => _AcquisitionsViewState();
}

class _AcquisitionsViewState extends State<AcquisitionsView> {
  int _switcherIndex = 0;
  final CapturesTab _capturesTab = const CapturesTab();
  final ProgressionTab _progressionTab = const ProgressionTab();
  final OptionsTab _optionsTab = const OptionsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(isUserDebuggingFeature: false),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.transparent,
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: const Text('Thomas Beauchamp',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold))),
            Center(
                child: SlideSwitcher(
              onSelect: (int index) => setState(() => _switcherIndex = index),
              slidersColors: const [primaryBackground],
              containerHeight: 40,
              containerWight: MediaQuery.of(context).size.width - 32,
              indents: 2,
              containerColor: primaryColorLight,
              children: const [
                Text(capturesTab,
                    style: TextStyle(
                      color: primaryColorDark,
                      fontWeight: FontWeight.bold,
                    )),
                Text(progressionTab,
                    style: TextStyle(
                      color: primaryColorDark,
                      fontWeight: FontWeight.bold,
                    )),
                Text(optionsTab,
                    style: TextStyle(
                      color: primaryColorDark,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            )),
            Expanded(
              child: IndexedStack(
                index: _switcherIndex,
                children: [
                  _capturesTab,
                  _progressionTab,
                  _optionsTab,
                ],
              ),
            )
          ],
        ));
  }
}
