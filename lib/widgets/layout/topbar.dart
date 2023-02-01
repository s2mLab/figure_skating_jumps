import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../buttons/XSensDotConnectionButton.dart';

class Topbar extends StatefulWidget {
  const Topbar({Key? key}): super(key: key);
  @override
  State<Topbar> createState() => _TopbarState();
}

class _TopbarState extends State<Topbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: primaryColor,
      height: 120,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () =>{},
                    iconSize: 48,
                    color: Color(0xFFFFFFFF),
                    icon: const Icon(Icons.menu_rounded),
                    padding: EdgeInsets.zero),
                Text('allo'),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  XSensDotConnectionButton()
                ],

              ),
            ),
          ],

        ),
      ),


    );
  }

}