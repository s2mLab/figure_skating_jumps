import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';
import '../../../services/user_client.dart';
import '../../buttons/nav_menu_element.dart';
import '../../views/raw_data_view.dart';

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
                        builder: (context) => const RawDataView()
                    ),
                  );
                }),
            NavMenuElement(
                text: "Mes acquisitions",
                iconData: Icons.history,
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/Acquisitions', arguments: UserClient().currentSkatingUser!
                  );
                }),
            NavMenuElement(
                text: "GodView",
                iconData: Icons.gavel_outlined,
                onPressed: () {
                  Navigator.pushNamed(
                      context,
                      '/',
                  );
                }),

          ],
        ),
      ),
    );
  }
}
