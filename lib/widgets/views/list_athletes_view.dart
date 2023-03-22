import 'package:collection/collection.dart';
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
  final double _heightContainer = 57;
  late Map<String, List<SkatingUser>> _traineesToShow;
  String _searchString = "";
  bool _loading = true;

  _loadData() async {
    if (!_loading) return;
    await _currentUser.loadTrainees();
    updateList();
    setState(() {
      _loading = false;
    });
  }

  updateList() {
    _traineesToShow = groupBy(_currentUser.trainees,
        (obj) => obj.firstName.toString().toUpperCase().substring(0, 1));
    _traineesToShow = Map.fromEntries(_traineesToShow.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    // if (_searchString.isEmpty) return;
    // for (int i = _traineesToShow.length - 1; i >= 0; i--) {
    //   bool isInFirstName = _traineesToShow[i]
    //       .firstName
    //       .toLowerCase()
    //       .contains(("bE").toLowerCase());
    //   bool isInLastName = _traineesToShow[i]
    //       .lastName
    //       .toLowerCase()
    //       .contains(("bE").toLowerCase());

    //   if (!isInFirstName && !isInLastName) {
    //     _traineesToShow.removeAt(i);
    //   }
    // }
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
                  child: _loading
                      ? const Center(
                          child: GFLoader(
                          size: 70,
                          loaderstrokeWidth: 5,
                        ))
                      : ListView.builder(
                          itemCount: _traineesToShow.length,
                          itemBuilder: (context, letterIndex) {
                            String key =
                                _traineesToShow.keys.elementAt(letterIndex);
                            List<SkatingUser> traineesByName =
                                _traineesToShow[key]!;
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    key,
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                      height: traineesByName.length *
                                          _heightContainer,
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: traineesByName.length,
                                        itemBuilder: (context, index) {
                                          SkatingUser item =
                                              traineesByName[index];
                                          return Container(
                                              margin: const EdgeInsets.only(
                                                  top: 4,
                                                  right: 4,
                                                  bottom: 4,
                                                  left: 24),
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                  color: cardBackground,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Text(
                                                "${item.firstName} ${item.lastName}",
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ));
                                        },
                                      ))
                                ]);
                          }))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: secondaryLight,
        child: const Icon(Icons.add),
      ),
    );
  }
}
