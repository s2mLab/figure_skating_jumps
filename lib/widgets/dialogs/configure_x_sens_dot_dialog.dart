import 'package:figure_skating_jumps/enums/x_sens_connection_state.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../icons/x_sens_state_icon.dart';

class ConfigureXSensDotDialog extends StatelessWidget {
  final String name;
  const ConfigureXSensDotDialog({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: primaryBackground,
        insetPadding:
            const EdgeInsets.only(left: 16, right: 16, top: 200, bottom: 200),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text(
                    name,
                    style: const TextStyle(
                        fontSize: 24, overflow: TextOverflow.ellipsis),
                  ))),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Center(
                  child: XSensStateIcon(false, XSensConnectionState.connected),
                ),
              ),
            ],
          ),
        ));
  }
}
