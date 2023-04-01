import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/widgets/dialogs/confirm_cancel_custom_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
                              builder: (context) => const RawDataView()),
                        );
                      }),
                  NavMenuElement(
                      text: myAcquisitions,
                      iconData: Icons.history,
                      onPressed: () {
                        Navigator.pushNamed(context, '/Acquisitions',
                            arguments: UserClient().currentSkatingUser!);
                      }),
                  if(UserClient().currentSkatingUser!.role == UserRole.coach) NavMenuElement(
                      text: myAthletes,
                      iconData: Icons.groups_rounded,
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/ListAthletes',
                        );
                      }),
                ],
              )),
              Container(
                  margin: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: IconButton(
                            onPressed: () async {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmCancelCustomDialog(
                                        description: disconnect,
                                        confirmAction: () {
                                          UserClient().signOut();
                                          Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
                                        });
                                  });
                            },
                            icon: const Icon(Icons.logout),
                            iconSize: 40,
                            color: errorColor,
                          )),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/ProfileView',
                          );
                        },
                        icon: const Icon(Icons.account_circle),
                        iconSize: 40,
                        color: secondaryColor,
                      )
                    ],
                  ))
            ]),
      ),
    );
  }
}
