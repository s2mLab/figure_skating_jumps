import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../constants/lang_fr.dart';
import '../../models/skating_user.dart';
import '../layout/scaffold/ice_drawer_menu.dart';

class ListAthletesView extends StatelessWidget {
  ListAthletesView({Key? key}) : super(key: key);

  final SkatingUser _currentUser = UserClient().currentSkatingUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(isUserDebuggingFeature: false),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.transparent,
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              children: [
                const PageTitle(text: listAthletesTitle),
                TextButton(
                    onPressed: () {
                      debugPrint(_currentUser.trainees.length.toString());
                    },
                    child: const Text('TEST'))
              ],
            )));
  }
}
