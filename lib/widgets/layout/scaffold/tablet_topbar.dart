import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_connection_button.dart';

class TabletTopbar extends StatefulWidget implements PreferredSizeWidget {
  final bool isUserDebuggingFeature;
  const TabletTopbar({required this.isUserDebuggingFeature, Key? key}) : super(key: key);
  @override
  State<TabletTopbar> createState() => _TabletTopbarState();

  @override
  final Size preferredSize = const Size.fromHeight(bigTopbarHeight);
}

class _TabletTopbarState extends State<TabletTopbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: widget.isUserDebuggingFeature ? darkText : primaryColor,
      height: bigTopbarHeight,
      child: Padding(
        padding: EdgeInsets.only(left: ReactiveLayoutHelper.getWidthFromFactor(16, true), right: ReactiveLayoutHelper.getWidthFromFactor(16, true), top: ReactiveLayoutHelper.getHeightFromFactor(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    iconSize: ReactiveLayoutHelper.getHeightFromFactor(48),
                    color: primaryBackground,
                    icon: const Icon(Icons.menu_rounded),
                    padding: EdgeInsets.zero),
                SizedBox(
                    height: ReactiveLayoutHelper.getHeightFromFactor(48),
                    width: ReactiveLayoutHelper.getWidthFromFactor(110),
                    child: SvgPicture.asset(
                        'assets/vectors/blanc-logo-patinage-quebec.svg')),
                SizedBox(
                  height: ReactiveLayoutHelper.getHeightFromFactor(48),
                  width: ReactiveLayoutHelper.getHeightFromFactor(48),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: ReactiveLayoutHelper.getHeightFromFactor(16)),
              child: const Center(
                child: XSensDotConnectionButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
