import 'package:collection/collection.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/tablet-topbar.dart';
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
  final double _heightContainer =
      ReactiveLayoutHelper.getHeightFromFactor(57); //57?
  late Map<String, List<SkatingUser>> _traineesToShow;
  late TextEditingController _searchController;
  late String _searchString = "";
  late FocusNode _focusNode;
  bool _searching = false;
  bool _loading = true;
  bool _state = false;

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
    _state = ModalRoute.of(context)!.settings.arguments as bool;
    if (_state) {
      setState(() {});
    }
    return Scaffold(
      appBar: ReactiveLayoutHelper.isTablet() ? const TabletTopbar(isUserDebuggingFeature: false) as PreferredSizeWidget : const Topbar(isUserDebuggingFeature: false),
      drawerEnableOpenDragGesture: false,
      drawerScrimColor: Colors.transparent,
      drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
      body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: ReactiveLayoutHelper.getHeightFromFactor(16),
                  horizontal: ReactiveLayoutHelper.getWidthFromFactor(16, true)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.only(
                          bottom: ReactiveLayoutHelper.getHeightFromFactor(8)),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const PageTitle(text: listAthletesTitle),
                            if (_loading || _traineesToShow.isNotEmpty)
                              _searching
                                  ? Container(
                                      height: ReactiveLayoutHelper
                                          .getHeightFromFactor(50),
                                      padding: EdgeInsets.only(
                                          top: ReactiveLayoutHelper
                                              .getHeightFromFactor(8),
                                          left: ReactiveLayoutHelper
                                              .getHeightFromFactor(16),
                                          bottom: ReactiveLayoutHelper
                                              .getHeightFromFactor(8)),
                                      decoration: BoxDecoration(
                                          color: cardBackground,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: Row(children: [
                                        SizedBox(
                                            width: ReactiveLayoutHelper
                                                .getHeightFromFactor(150),
                                            child: Focus(
                                                onFocusChange: (hasFocus) =>
                                                    _searchFocusChanged(
                                                        hasFocus),
                                                child: TextField(
                                                  style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
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
                                          icon:
                                              const Icon(Icons.cancel_outlined),
                                          color: discreetText,
                                          padding: EdgeInsets.zero,
                                          iconSize: ReactiveLayoutHelper
                                              .getHeightFromFactor(30),
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
                                          iconSize: ReactiveLayoutHelper.getHeightFromFactor(30),
                                          icon: const Icon(Icons.search)))
                          ])),
                  Expanded(
                      child: _loading
                          ? const Center(
                              child: GFLoader(
                              size: 70,
                              loaderstrokeWidth: 5,
                            ))
                          : _traineesToShow.isEmpty
                              ? Center(
                                  child: Text(noAthletes,
                                      textAlign: TextAlign.center, style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),))
                              : ListView.builder(
                                  itemCount: _traineesToShow.length,
                                  itemBuilder: (context, letterIndex) {
                                    String key = _traineesToShow.keys
                                        .elementAt(letterIndex);
                                    List<SkatingUser> traineesByName =
                                        _traineesToShow[key]!;
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (traineesByName.isNotEmpty)
                                            Text(
                                              key,
                                              style: TextStyle(
                                                  fontSize: ReactiveLayoutHelper
                                                      .getHeightFromFactor(20),
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          SizedBox(
                                              height: traineesByName.length *
                                                  _heightContainer,
                                              child: ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount:
                                                    traineesByName.length,
                                                itemBuilder: (context, index) {
                                                  SkatingUser item =
                                                      traineesByName[index];
                                                  return GestureDetector(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            '/Acquisitions',
                                                            arguments: item);
                                                      },
                                                      child: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                            top: ReactiveLayoutHelper
                                                                .getHeightFromFactor(
                                                                    4),
                                                            right: ReactiveLayoutHelper
                                                                .getWidthFromFactor(
                                                                    4),
                                                            bottom: ReactiveLayoutHelper
                                                                .getHeightFromFactor(
                                                                    4),
                                                            left: ReactiveLayoutHelper
                                                                .getWidthFromFactor(
                                                                    24),
                                                          ),
                                                          padding: EdgeInsets.symmetric(
                                                              horizontal:
                                                                  ReactiveLayoutHelper
                                                                      .getWidthFromFactor(
                                                                          12),
                                                              vertical:
                                                                  ReactiveLayoutHelper
                                                                      .getHeightFromFactor(
                                                                          12)),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  cardBackground,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Text(
                                                            "${item.firstName} ${item.lastName}",
                                                            style:
                                                                TextStyle(
                                                                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
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
