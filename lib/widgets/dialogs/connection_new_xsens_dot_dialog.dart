import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens_connection_state.dart';
import 'package:figure_skating_jumps/interfaces/bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/bluetooth_discovery.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
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
                configureAndConfirm(),
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
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: primaryColorDark,
                    value: null,
                  ),
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
                  child: XSensDotListElement(
                    text: devices[index].name,
                    graphic: const XSensStateIcon(
                        true, XSensConnectionState.disconnected),
                  ),
                );
              }),
        )),
        Center(
            child: IceButton(
                text: 'Continuer temporaire',
                onPressed: () {
                  setState(() {
                    _connectionStep = 1;
                  });
                },
                textColor: primaryColor,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.secondaryAction,
                iceButtonSize: IceButtonSize.medium)),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: IceButton(
              text: 'Annuler',
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

  Widget verifyStep() {
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
          child: InstructionPrompt(
              'Vérifier la réception du capteur (1/2)', secondaryColor),
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
              text: 'Poursuivre le jumelage',
              onPressed: () {
                setState(() {
                  _connectionStep = 2;
                });
              },
              textColor: paleText,
              color: primaryColor,
              iceButtonImportance: IceButtonImportance.mainAction,
              iceButtonSize: IceButtonSize.large),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: IceButton(
              text: 'Annuler',
              onPressed: () {
                setState(() {
                  _connectionStep =
                      0; // TODO: Deselect chosen XSensDOT instance when available
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

  Widget configureAndConfirm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Center(
              child: XSensStateIcon(false, XSensConnectionState.connected)),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: InstructionPrompt(
              'Configurer la fréquence de réception (2/2)', secondaryColor),
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
              text:
                  'Compléter le jumelage', // TODO: Forbid if frequency hasn't been chosen
              onPressed: () {
                // TODO: Pair the device.
              },
              textColor: paleText,
              color: confirm,
              iceButtonImportance: IceButtonImportance.mainAction,
              iceButtonSize: IceButtonSize.large),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: IceButton(
              text: 'Annuler le jumelage',
              onPressed: () {
                Navigator.pop(context,
                    true); // TODO: Delete programmatically assigned XSENS DOT connector value when available
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
    this.devices = devices;
    setState(() {});
  }
}
