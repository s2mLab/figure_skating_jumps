import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:flutter/material.dart';

import '../layout/scaffold/ice_drawer_menu.dart';

class ListAthletesView extends StatelessWidget {
  const ListAthletesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(isUserDebuggingFeature: false),
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: Container());
  }
}
