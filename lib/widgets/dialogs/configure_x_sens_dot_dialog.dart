import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/manager/device_names_manager.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_bluetooth_discovery_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../icons/x_sens_state_icon.dart';
import '../prompts/ice_field_editable.dart';

class ConfigureXSensDotDialog extends StatelessWidget {
  final BluetoothDevice xSensDot;
  final Function() close;

  const ConfigureXSensDotDialog(
      {required this.xSensDot, super.key, required this.close});

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
                    xSensDot.assignedName = newText;
                  },
                  text: xSensDot.assignedName),
              IceButton(
                  text: forgetDevice,
                  onPressed: () async {
                    await DeviceNamesManager().removeDevice(xSensDot);
                    close();
                  },
                  textColor: errorColor,
                  color: errorColorDark,
                  iceButtonImportance: IceButtonImportance.discreetAction,
                  iceButtonSize: IceButtonSize.medium),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Center(
                  child: XSensStateIcon(
                      false,
                      _isDeviceConnected()
                          ? XSensDeviceState.connected
                          : XSensDeviceState.disconnected),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: _connectionManagementButton()),
              IceButton(
                  text: goBack,
                  onPressed: () {
                    close();
                  },
                  textColor: paleText,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.mainAction,
                  iceButtonSize: IceButtonSize.large),
            ],
          ),
        ));
  }

  Widget _connectionManagementButton() {
    if (_isDeviceConnected()) {
      return IceButton(
          text: disconnectDevice,
          onPressed: () async {
            await XSensDotConnectionService().disconnect();
            close();
          },
          textColor: errorColor,
          color: errorColor,
          iceButtonImportance: IceButtonImportance.secondaryAction,
          iceButtonSize: IceButtonSize.large);
    }

    bool isNear = XSensDotBluetoothDiscoveryService()
        .getDevices()
        .any((element) => element.macAddress == xSensDot.macAddress);
    return isNear
        ? IceButton(
            text: connectDevice,
            onPressed: () async {
              //A possible race condition, to test
              await XSensDotConnectionService().disconnect();
              await XSensDotConnectionService().connect(xSensDot);
              close();
            },
            textColor: primaryColor,
            color: primaryColor,
            iceButtonImportance: IceButtonImportance.secondaryAction,
            iceButtonSize: IceButtonSize.large)
        : const SizedBox(height: 56);
  }

  bool _isDeviceConnected() {
    return XSensDotConnectionService().currentXSensDevice != null &&
        xSensDot.macAddress ==
            XSensDotConnectionService().currentXSensDevice?.macAddress;
  }
}
