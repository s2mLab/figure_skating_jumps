import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/widgets/layout/progression_tab.dart';
import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';
import '../../constants/colors.dart';
import '../layout/captures_tab.dart';
import '../layout/ice_drawer_menu.dart';
import '../layout/options_tab.dart';
import '../layout/topbar.dart';

class AcquisitionsView extends StatefulWidget {
  const AcquisitionsView({Key? key, required this.skater}) : super(key: key);

  final SkatingUser skater;

  @override
  _AcquisitionsViewState createState() => _AcquisitionsViewState();
}

class _AcquisitionsViewState extends State<AcquisitionsView> {
  int _switcherIndex = 0;
  bool loadingData = true;
  late CapturesTab _capturesTab;
  final ProgressionTab _progressionTab = const ProgressionTab();
  final OptionsTab _optionsTab = const OptionsTab();
  final List<Capture> _captures = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _captureCollectionString = 'captures';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCapturesData());
  }

  _loadCapturesData() async {
    for (String captureID in widget.skater.captures) {
      _captures.add(await Capture.create(
          captureID,
          await _firestore
              .collection(_captureCollectionString)
              .doc(captureID)
              .get()));
    }

    _capturesTab = CapturesTab(captures: _captures);

    setState(() {
      loadingData = false;
    });
  }

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
                child: Text(widget.skater.firstName,
                    style: const TextStyle(
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
            loadingData
                ? const Center(child: Text("Loading..."))
                : Expanded(
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
