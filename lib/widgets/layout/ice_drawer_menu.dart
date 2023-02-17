import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../buttons/nav_menu_element.dart';
import '../screens/raw_data_view.dart';

class IceDrawerMenu extends StatelessWidget {
  const IceDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 128.0),
      child: Drawer(
        backgroundColor: primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            NavMenuElement(text: rawDataDrawerTile, iconData: Icons.terminal, onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute( // TODO: remove periodic stream and instantiate with xsensdot device datastream
                    builder: (context) => RawDataView(logStream: Stream.periodic(
                      const Duration(milliseconds: 300),
                          (count) => 'Log entry $count',
                    ).take(50),)),
              );
            }),
          ],
        ),
      ),
    );
  }

}