import 'package:flutter/material.dart';
import 'package:slide_switcher/slide_switcher.dart';
import '../../constants/colors.dart';
import '../layout/ice_drawer_menu.dart';
import '../layout/topbar.dart';

class AcquisitionsView extends StatefulWidget {
  const AcquisitionsView({Key? key}) : super(key: key);

  @override
  _AcquisitionsViewState createState() => _AcquisitionsViewState();
}

class _AcquisitionsViewState extends State<AcquisitionsView> {
  int switcherIndex = 0;

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
                child: const Text('Thomas Beauchamp',
                    style: TextStyle(
                        color: primaryColor,
                        fontSize: 25,
                        fontWeight: FontWeight.bold))),
            SlideSwitcher(
              children: const [
                Text(
                  'First',
                  style: TextStyle(
                    color: Color.fromRGBO(53, 90, 242, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Second',
                  style: TextStyle(
                    color: Color.fromRGBO(53, 90, 242, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Third',
                  style: TextStyle(
                    color: Color.fromRGBO(53, 90, 242, 1),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              onSelect: (int index) => setState(() => switcherIndex = index),
              slidersColors: const [Colors.white],
              containerHeight: 60,
              containerWight: 350,
              indents: 5,
              containerColor: primaryColorLight,
            ),
          ],
        ));
  }
}
