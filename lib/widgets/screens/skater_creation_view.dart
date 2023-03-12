import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../layout/ice_drawer_menu.dart';
import '../layout/topbar.dart';
import '../prompts/instruction_prompt.dart';
import '../titles/page_title.dart';

class SkaterCreationView extends StatefulWidget {
  const SkaterCreationView({super.key});

  @override
  State<SkaterCreationView> createState() => _SkaterCreationViewState();
}

class _SkaterCreationViewState extends State<SkaterCreationView> {
  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(isUserDebuggingFeature: false),
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        drawerScrimColor: Colors.transparent,
        drawerEnableOpenDragGesture: false,
        body: GestureDetector(onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        }, child:
          SingleChildScrollView(child:
          Container(
            height: MediaQuery.of(context).size.height - 128,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: primaryBackground,
              borderRadius:
              const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                // TODO: might want to save the boxshadow value in a style file for future use
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(
                      0, 4), // changes position of shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 24.0, top: 8.0),
                    child: PageTitle(text: "Ajout d'un patineur"),
                  ),
                  const InstructionPrompt(
                      createAthleteExplainPrompt, secondaryColor),
                  Expanded(
                    child: IndexedStack(
                      index: _pageIndex,
                      children: const [],
                    ),
                  )
                ],
              ),
            ),
          )
            ,),
          ));
  }

  void _toPassword() {
    setState(() {
      _pageIndex = 1;
    });
  }

  void _toInformation() {
    setState(() {
      _pageIndex = 1;
    });
  }
}
