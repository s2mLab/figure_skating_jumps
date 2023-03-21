import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../constants/lang_fr.dart';
import '../../models/skating_user.dart';
import '../layout/scaffold/ice_drawer_menu.dart';

class ListAthletesView extends StatefulWidget {
  const ListAthletesView({Key? key}) : super(key: key);

  @override
  State<ListAthletesView> createState() {
    return _ListAthletesViewState();
  }
}

class _ListAthletesViewState extends State<ListAthletesView> {
  final SkatingUser _currentUser = UserClient().currentSkatingUser!;
  bool loading = true;

  _loadData() async {
    if (!loading) return;
    await _currentUser.loadTrainees();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
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
                    child: loading
                        ? const Center(
                            child: GFLoader(
                            size: 70,
                            loaderstrokeWidth: 5,
                          ))
                        : ListView.builder(
                            itemCount: _currentUser.traineesID.length,
                            itemBuilder: (context, index) {
                              String item = _currentUser.traineesID[index];
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
