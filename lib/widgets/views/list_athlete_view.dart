import 'package:figure_skating_jumps/constants/colors.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const PageTitle(text: listAthletesTitle),
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: cardBackground,
                                  borderRadius: BorderRadius.circular(30)),
                              child: const Icon(Icons.search))
                        ])),
                Expanded(
                    child: ListView.builder(
                        itemCount: _currentUser.trainees.length,
                        itemBuilder: (context, index) {
                          String item = _currentUser.trainees[index];
                          return Container(
                              margin: const EdgeInsets.all(4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: cardBackground,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(item));
                        }))
              ],
            )));
  }
}
