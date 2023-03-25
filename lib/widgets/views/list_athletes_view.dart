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
  static const int _maxLengthSearch = 11;

  late final SkatingUser _currentUser;
  final double _heightContainer = 57;
  late Map<String, List<SkatingUser>> _traineesToShow;
  late TextEditingController _searchController;
  late String _searchString = "";
  late FocusNode _focusNode;
  bool _searching = false;
  bool _loading = true;

  @override
  void initState() {
    _currentUser = UserClient().currentSkatingUser!;
    _searchController = TextEditingController(text: _searchString);
    _focusNode = FocusNode();
    super.initState();
  }

  _loadData() async {
    if (!_loading) return;
    await _currentUser.loadTrainees();
    _updateList();
    setState(() {
      _loading = false;
    });
  }

  _searchFocusChanged(bool hasFocus) {
    setState(() {
      _searching = hasFocus || _searchController.text.isNotEmpty;
    });
  }

  _updateList() {
    _traineesToShow = groupBy(_currentUser.trainees,
        (obj) => obj.firstName.toString().toUpperCase().substring(0, 1));
    _traineesToShow = Map.fromEntries(_traineesToShow.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

    _searchString = _searchController.text;
    debugPrint(_searchString);
    if (_searchString.isEmpty) {
      setState(() {});
      return;
    }

    for (String nameIndex in _traineesToShow.keys) {
      for (int i = _traineesToShow[nameIndex]!.length - 1; i >= 0; i--) {
        SkatingUser trainee = _traineesToShow[nameIndex]![i];
        bool isInFirstName = trainee.firstName
            .toLowerCase()
            .contains(_searchString.toLowerCase());
        bool isInLastName = trainee.lastName
            .toLowerCase()
            .contains(_searchString.toLowerCase());
        if (!isInFirstName && !isInLastName) {
          _traineesToShow[nameIndex]!.removeAt(i);
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
      appBar: const Topbar(isUserDebuggingFeature: false),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
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
                            _searching
                                ? Container(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                        top: 8, left: 16, bottom: 8),
                                    decoration: BoxDecoration(
                                        color: cardBackground,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Row(children: [
                                      SizedBox(
                                          width: 150,
                                          child: Focus(
                                              onFocusChange: (hasFocus) =>
                                                  _searchFocusChanged(hasFocus),
                                              child: TextField(
                                                maxLength: _maxLengthSearch,
                                                focusNode: _focusNode,
                                                controller: _searchController,
                                                onChanged: (value) =>
                                                    _updateList(),
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        counterText: ""),
                                              ))),
                                      IconButton(
                                        icon: const Icon(Icons.cancel_outlined),
                                        color: discreetText,
                                        padding: const EdgeInsets.all(0),
                                        iconSize: 30,
                                        onPressed: () {
                                          _searchController.clear();
                                          _updateList();
                                          _searchFocusChanged(false);
                                        },
                                      )
                                    ]))
                                : Container(
                                    decoration: BoxDecoration(
                                        color: cardBackground,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _searching = true;
                                          });
                                          _focusNode.requestFocus();
                                        },
                                        icon: const Icon(Icons.search)))
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (traineesByName.isNotEmpty)
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
                                              return GestureDetector(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        '/Acquisitions',
                                                        arguments: item);
                                                  },
                                                  child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              top: 4,
                                                              right: 4,
                                                              bottom: 4,
                                                              left: 24),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12),
                                                      decoration: BoxDecoration(
                                                          color: cardBackground,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Text(
                                                        "${item.firstName} ${item.lastName}",
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      )));
                                            },
                                          ))
                                    ]);
                              }))
                ],
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/CreateSkater');
        },
        backgroundColor: secondaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
