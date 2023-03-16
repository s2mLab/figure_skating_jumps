import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/models/capture.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/widgets/layout/progression_tab.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import '../layout/captures_tab.dart';
import '../layout/ice_drawer_menu.dart';
import '../layout/options_tab.dart';
import '../layout/topbar.dart';

class AcquisitionsView extends StatefulWidget {
  const AcquisitionsView({Key? key}) : super(key: key);

  @override
  State<AcquisitionsView> createState() {
    return _AcquisitionsViewState();
  }
}

class _AcquisitionsViewState extends State<AcquisitionsView> {
  int _switcherIndex = 0;
  bool loadingData = true;
  late Map<String, List<Capture>> _capturesSorted;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _captureCollectionString = 'captures';

  @override
  void initState() {
    super.initState();
    //WidgetsBinding.instance.addPostFrameCallback((_) => _loadCapturesData());
  }

  _loadCapturesData(SkatingUser skater) async {
    List<Capture> captures = [];
    for (String captureID in skater.captures) {
      captures.add(await Capture.createFromFireBase(
          captureID,
          await _firestore
              .collection(_captureCollectionString)
              .doc(captureID)
              .get()));
    }

    _capturesSorted =
        groupBy(captures, (obj) => obj.date.toString().substring(0, 10));

    setState(() {
      loadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final SkatingUser skater =
        ModalRoute.of(context)!.settings.arguments as SkatingUser;
    _loadCapturesData(skater);
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
                child: PageTitle(text: skater.firstName)),
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
              child: loadingData
                  ? const Center(
                      child: GFLoader(
                      size: 70,
                      loaderstrokeWidth: 5,
                    ))
                  : IndexedStack(
                      index: _switcherIndex,
                      children: [
                        CapturesTab(captures: _capturesSorted),
                        const ProgressionTab(),
                        const OptionsTab(),
                      ],
                    ),
            )
          ],
        ));
  }
}
