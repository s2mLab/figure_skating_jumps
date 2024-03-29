import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:figure_skating_jumps/enums/models/user_role.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/widgets/buttons/nav_menu_element.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/dialogs/helper_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/confirm_logout_dialog.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class IceDrawerMenu extends StatelessWidget {
  final bool isUserDebuggingFeature;
  const IceDrawerMenu({super.key, required this.isUserDebuggingFeature});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top:
              ReactiveLayoutHelper.isTablet() ? bigTopbarHeight : topbarHeight),
      child: Drawer(
        elevation: 0,
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
                        Navigator.popAndPushNamed(
                          context,
                          '/ManageDevices',
                        );
                      }),
                  NavMenuElement(
                      text: addSkaterDrawerTile,
                      iconData: Icons.add_reaction_outlined,
                      onPressed: () {
                        Navigator.popAndPushNamed(
                          context,
                          '/CreateSkater',
                        );
                      }),
                  NavMenuElement(
                      text: myAcquisitionsTitle,
                      iconData: Icons.history,
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/Captures',
                            arguments: UserClient().currentSkatingUser!);
                      }),
                  if (UserClient().currentSkatingUser!.role == UserRole.coach)
                    NavMenuElement(
                        text: myAthletesTitle,
                        iconData: Icons.groups_rounded,
                        onPressed: () {
                          Navigator.popAndPushNamed(
                            context,
                            '/ListAthletes',
                            arguments: true,
                          );
                        }),
                ],
              )),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                NavMenuElement(
                    text: rawDataDrawerTile,
                    iconData: Icons.terminal,
                    onPressed: () {
                      Navigator.popAndPushNamed(
                        context,
                        '/RawData',
                      );
                    }),
                Padding(
                  padding: ReactiveLayoutHelper.isTablet()
                      ? EdgeInsets.symmetric(
                          vertical:
                              ReactiveLayoutHelper.getHeightFromFactor(16),
                          horizontal:
                              ReactiveLayoutHelper.getWidthFromFactor(16))
                      : const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return const HelperDialog();
                              });
                        },
                        icon: const Icon(Icons.help_outline),
                        iconSize: ReactiveLayoutHelper.isTablet()
                            ? ReactiveLayoutHelper.getHeightFromFactor(40)
                            : 40,
                        color: discreetText,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: ReactiveLayoutHelper.isTablet()
                                ? ReactiveLayoutHelper.getHeightFromFactor(16)
                                : 16),
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
                                          return ConfirmLogoutDialog(
                                              confirmAction: () async {
                                                await UserClient().signOut();
                                                if (context.mounted) {
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          '/Login',
                                                          (route) => false);
                                                }
                                              });
                                        });
                                  },
                                  icon: const Icon(Icons.logout),
                                  iconSize: ReactiveLayoutHelper.isTablet()
                                      ? ReactiveLayoutHelper
                                          .getHeightFromFactor(40)
                                      : 40,
                                  color: errorColor,
                                )),
                            IconButton(
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                  context,
                                  '/Profile',
                                );
                              },
                              icon: const Icon(Icons.account_circle),
                              iconSize: ReactiveLayoutHelper.isTablet()
                                  ? ReactiveLayoutHelper.getHeightFromFactor(40)
                                  : 40,
                              color: secondaryColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ])
            ]),
      ),
    );
  }
}
