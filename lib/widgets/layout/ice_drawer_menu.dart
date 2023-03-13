import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../buttons/nav_menu_element.dart';
import '../screens/raw_data_view.dart';

class IceDrawerMenu extends StatelessWidget {
  final bool isUserDebuggingFeature;
  const IceDrawerMenu({super.key, required this.isUserDebuggingFeature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: topbarHeight),
      child: Drawer(
        backgroundColor: isUserDebuggingFeature ? darkText : primaryColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            NavMenuElement(
                text: manageDevicesDrawerTile,
                iconData: Icons.settings_bluetooth_outlined,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/ManageDevices',
                  );
                }),
            NavMenuElement(
                text: addSkaterDrawerTile,
                iconData: Icons.add_reaction_outlined,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/CreateSkater',
                  );
                }),
            NavMenuElement(
                text: rawDataDrawerTile,
                iconData: Icons.terminal,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        // TODO: remove periodic stream and instantiate with xsensdot device datastream
                        builder: (context) => RawDataView(
                              logStream: Stream.periodic(
                                const Duration(milliseconds: 300),
                                (count) => 'Log entry $count',
                              ).take(50),
                            )),
                  );
                }),

          ],
        ),
      ),
    );
  }
}
