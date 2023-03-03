import 'dart:async';

import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens_connection_state.dart';
import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/bluetooth_discovery.dart';
import 'package:figure_skating_jumps/services/x_sens_dot_channel_service.dart';
import 'package:figure_skating_jumps/services/x_sens_dot_connection.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';

class ConnectionNewXSensDotDialog extends StatefulWidget {
  const ConnectionNewXSensDotDialog({super.key});

  @override
  State<ConnectionNewXSensDotDialog> createState() =>
      _ConnectionNewXSensDotState();
}

class _ConnectionNewXSensDotState extends State<ConnectionNewXSensDotDialog>
    implements IBluetoothDiscoverySubscriber {
  static const int defaultFrequency = 60;

  int _connectionStep = 0;
  List<BluetoothDevice> _devices = [];
  final BluetoothDiscovery _discoveryService = BluetoothDiscovery();
  final XSensDotConnection _xSensDotConnectionService = XSensDotConnection();
  final XSensDotChannelService _xSensDotChannelService =
      XSensDotChannelService();
  final Duration _refreshDelay = const Duration(seconds: 10);
  late Timer _scanDeviceTimer;

  @override
  void initState() {
    _devices = _discoveryService.subscribeBluetoothDiscovery(this);
    _discoveryService.refreshFromKotlinHandle();
    _scanDeviceTimer = Timer.periodic(_refreshDelay, (_) {
      if (_connectionStep == 0) {
        _discoveryService.refreshFromKotlinHandle();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scanDeviceTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: primaryBackground,
      insetPadding:
          const EdgeInsets.only(left: 16, right: 16, top: 104, bottom: 104),
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: primaryColorLight,
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  newXSensConnectionDialogTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: paleText, fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _connectionStep,
              children: [
                _newPairingStep(),
                _verifyStep(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _newPairingStep() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child:
              InstructionPrompt(bluetoothAuthorizationPrompt, secondaryColor),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: primaryColorDark,
                    value: null,
                  ),
                ),
              ),
              Text(searching)
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: XSensDotListElement(
                    hasLine: true,
                    text: _devices[index].name,
                    graphic: const XSensStateIcon(
                        true, XSensConnectionState.disconnected),
                    onPressed: () async {
                      await _onDevicePressed(_devices[index]);
                    },
                  ),
                );
              }),
        )),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: IceButton(
              text: cancel,
              onPressed: () {
                Navigator.pop(context, true);
              },
              textColor: primaryColor,
              color: primaryColor,
              iceButtonImportance: IceButtonImportance.secondaryAction,
              iceButtonSize: IceButtonSize.large),
        ),
      ],
    );
  }

  Widget _verifyStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
              child: XSensStateIcon(false, XSensConnectionState.reconnecting)),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: InstructionPrompt(verifyConnectivity, secondaryColor),
        ),
        Expanded(
            child: Container(
          color: Colors.pink,
          height: 60,
          width: 300,
        )),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: IceButton(
              text: completePairing,
              // TODO: Forbid if frequency hasn't been chosen
              onPressed: () {
                // TODO: Send the configuration to the device.
                Navigator.pop(context);
              },
              textColor: paleText,
              color: confirm,
              iceButtonImportance: IceButtonImportance.mainAction,
              iceButtonSize: IceButtonSize.large),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: IceButton(
              text: cancel,
              onPressed: () async {
                await _xSensDotConnectionService.disconnect();
                setState(() {
                  _connectionStep = 0;
                });
              },
              textColor: primaryColor,
              color: primaryColor,
              iceButtonImportance: IceButtonImportance.secondaryAction,
              iceButtonSize: IceButtonSize.large),
        ),
      ],
    );
  }

  @override
  void onBluetoothDeviceListChange(List<BluetoothDevice> devices) {
    if (mounted) {
      setState(() {
        _devices = devices;
      });
    }
  }

  Future<void> _onDevicePressed(BluetoothDevice device) async {
    if (await _xSensDotConnectionService.connect(device)) {
      _xSensDotChannelService.setRate(defaultFrequency);
      setState(() {
        _connectionStep = 1;
      });
    }
    //TODO show error message (when I will have the UI model to do so)
  }
}
