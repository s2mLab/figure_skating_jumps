import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:flutter/material.dart';

import '../buttons/x_sens_dot_connection_button.dart';

class Topbar extends StatefulWidget implements PreferredSizeWidget {
  const Topbar({Key? key}) : super(key: key);
  @override
  State<Topbar> createState() => _TopbarState();

  @override
  final Size preferredSize = const Size.fromHeight(128);
}

class _TopbarState extends State<Topbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: primaryColor,
      height: 128,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    iconSize: 48,
                    color: primaryBackground,
                    icon: const Icon(Icons.menu_rounded),
                    padding: EdgeInsets.zero),
                Container(
                  height: 40,
                  width: 40,
                  color: primaryColorLight,
                ),
                const SizedBox(
                  height: 48,
                  width: 48,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Center(
                child: XSensDotConnectionButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
