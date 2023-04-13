import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/manager/bluetooth_device_manager.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_bluetooth_discovery_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:figure_skating_jumps/widgets/prompts/ice_field_editable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfigureXSensDotDialog extends StatelessWidget {
  final BluetoothDevice xSensDot;
  final Function() close;

  const ConfigureXSensDotDialog(
      {required this.xSensDot, super.key, required this.close});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: primaryBackground,
        insetPadding: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getWidthFromFactor(16)),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getWidthFromFactor(24), vertical: ReactiveLayoutHelper.getHeightFromFactor(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IceFieldEditable(
                  onEditComplete: (String newText) {
                    xSensDot.name = newText;
                  },
                  text: xSensDot.name),
              IceButton(
                  text: forgetDeviceButton,
                  onPressed: () async {
                    await BluetoothDeviceManager().removeDevice(xSensDot);
                    close();
                  },
                  textColor: errorColor,
                  color: errorColorDark,
                  iceButtonImportance: IceButtonImportance.discreetAction,
                  iceButtonSize: IceButtonSize.medium),
              Padding(
                padding: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(24)),
                child: Center(
                  child: XSensStateIcon(
                      false,
                      _isDeviceConnected()
                          ? XSensDeviceState.connected
                          : XSensDeviceState.disconnected),
                ),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(16)),
                  child: _connectionManagementButton()),
              IceButton(
                  text: goBackLabel,
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
          text: disconnectDeviceButton,
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
            text: connectDeviceButton,
            onPressed: () async {
              await XSensDotConnectionService().disconnect();
              if (await XSensDotConnectionService().connect(xSensDot)) {
                close();
              } else {
                Fluttertoast.showToast(
                    msg: connectionErrorLabel + xSensDot.macAddress);
                debugPrint(
                    "Connection to device ${xSensDot.macAddress} failed");
              }
            },
            textColor: primaryColor,
            color: primaryColor,
            iceButtonImportance: IceButtonImportance.secondaryAction,
            iceButtonSize: IceButtonSize.large)
        : SizedBox(height: ReactiveLayoutHelper.getHeightFromFactor(56));
  }

  bool _isDeviceConnected() {
    return XSensDotConnectionService().currentXSensDevice != null &&
        xSensDot.macAddress ==
            XSensDotConnectionService().currentXSensDevice?.macAddress;
  }
}
