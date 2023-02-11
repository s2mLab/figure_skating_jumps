import 'package:figure_skating_jumps/enums/x_sens_connection_state.dart';
import 'package:figure_skating_jumps/interfaces/bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/bluetooth_discovery.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ConnectionNewXSensDotDialog extends StatefulWidget {
  const ConnectionNewXSensDotDialog({super.key});
  @override
  State<ConnectionNewXSensDotDialog> createState() =>
      _ConnectionNewXSensDotState();
}

class _ConnectionNewXSensDotState extends State<ConnectionNewXSensDotDialog>
    implements BluetoothDiscoverySubscriber {
  int _connectionStep = 0;
  List<BluetoothDevice> devices = [];
  BluetoothDiscovery discoveryService = BluetoothDiscovery();

  @override
  void initState() {
    devices = discoveryService.subscribeBluetoothDiscovery(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
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
                  'Connecter un nouvel XSens DOT',
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
                newPairingStep(),
                verifyStep(),
                TextButton(
                    onPressed: toSearch,
                    child: const InstructionPrompt(
                        'Confirmed and configured!', secondaryColor)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void toSearch() {
    setState(() {
      _connectionStep = 0;
    });
  }

  void toConfiguration() {
    setState(() {
      _connectionStep = 2;
    });
  }

  Widget newPairingStep() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: InstructionPrompt(
              'Veuillez donner l’autorisation à l’application d’accéder au Bluetooth. L’option se trouve généralement dans les paramètres de votre appareil.',
              secondaryColor),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircularProgressIndicator(
                  color: primaryColorDark,
                  value: null,
                ),
              ),
              Text('Recherche en cours', style: TextStyle(fontFamily: 'Jost'))
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView.builder(
              itemCount: devices.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child:
                      InstructionPrompt(devices[index].name, primaryColorLight),
                );
              }),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
                onPressed: () {
                  discoveryService.removeEntry();
                },
                child: const Text('test enlever', textAlign: TextAlign.center)),
            ElevatedButton(
                onPressed: () {
                  discoveryService.changeList();
                },
                child: const Text('test ajouter', textAlign: TextAlign.center)),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _connectionStep = 1;
                  });
                },
                child:
                    const Text('test continuer', textAlign: TextAlign.center)),
          ],
        ),
      ],
    );
  }

  Widget verifyStep() {
    return Column(
      children: const [
        XSensStateIcon(false, XSensConnectionState.reconnecting),

      ],
    );
  }

  @override
  void onBluetoothDeviceListChange(List<BluetoothDevice> devices) {
    this.devices = devices;
    setState(() {});
  }
}
