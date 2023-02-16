import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens_connection_state.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../services/bluetooth_discovery.dart';
import '../icons/x_sens_state_icon.dart';
import '../prompts/ice_field_editable.dart';

class ConfigureXSensDotDialog extends StatelessWidget {
  final String name;
  const ConfigureXSensDotDialog({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: primaryBackground,
        insetPadding: const EdgeInsets.only(left: 16, right: 16),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IceFieldEditable(
                  onEditComplete: (String newText) {
                    BluetoothDiscovery().getDevices()[0].assignedName = newText;
                  },
                  text: name),
              IceButton(
                  text: forgetDevice,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: errorColor,
                  color: errorColor,
                  iceButtonImportance: IceButtonImportance.discreetAction,
                  iceButtonSize: IceButtonSize.medium),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: XSensStateIcon(false, XSensConnectionState.connected),
                ),
              ),
              Container(
                color: Colors.pink, //TODO: Frequency configuration
                height: 60,
                child: const Text("TODO: Frequency configuration"),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: IceButton(
                      text: disconnectDevice,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      textColor: errorColor,
                      color: errorColor,
                      iceButtonImportance: IceButtonImportance.secondaryAction,
                      iceButtonSize: IceButtonSize.large)),
              IceButton(
                  text: goBack,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  textColor: paleText,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.mainAction,
                  iceButtonSize: IceButtonSize.large),
            ],
          ),
        ));
  }
}
