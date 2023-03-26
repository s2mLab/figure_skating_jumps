import 'dart:async';

import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';
import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/bluetooth_discovery.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
  final List<_DummyTempSkatingData> _data = [
    _DummyTempSkatingData('23/02', 35),
    _DummyTempSkatingData('27/02', 28),
    _DummyTempSkatingData('7/03', 34),
    _DummyTempSkatingData('8/03', 32),
    _DummyTempSkatingData('16/03', 40)
  ];
  final List<_DummyTempSkatingData> _data2 = [
    _DummyTempSkatingData('23/02', 15),
    _DummyTempSkatingData('27/02', 18),
    _DummyTempSkatingData('7/03', 44),
    _DummyTempSkatingData('8/03', 12),
    _DummyTempSkatingData('16/03', 10)
  ];

  final List<_DummyTempSkatingData> _data3 = [
    _DummyTempSkatingData('23/02', 25),
    _DummyTempSkatingData('27/02', 22),
    _DummyTempSkatingData('7/03', 24),
    _DummyTempSkatingData('8/03', 21),
    _DummyTempSkatingData('16/03', 27)
  ];
  int _connectionStep = 0;
  List<BluetoothDevice> _devices = [];
  final BluetoothDiscovery _discoveryService = BluetoothDiscovery();
  final XSensDotConnectionService _xSensDotConnectionService =
      XSensDotConnectionService();

  //final XSensDotChannelService _xSensDotChannelService = XSensDotChannelService(); waiting Christophe MR to override comment

  @override
  void initState() {
    _devices = _discoveryService.subscribe(this);
    _discoveryService.scanDevices();
    super.initState();
  }

  @override
  void dispose() {
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
                    text: _devices[index].assignedName,
                    graphic: const XSensStateIcon(
                        true, XSensDeviceState.disconnected),
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
              //TODO connecting before changing lists in top XSENS button
              child: XSensStateIcon(false, XSensDeviceState.connecting)),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: InstructionPrompt(verifyConnectivity, secondaryColor),
        ),
        Expanded(
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(decimalPlaces: 2, rangePadding: ChartRangePadding.round),
              // Chart title
              title: ChartTitle(
                  text: 'Acceleration',
                  textStyle: const TextStyle(fontSize: 12.0, fontFamily: 'Jost'),
                  alignment: ChartAlignment.near),
              // Enable legend
              legend: Legend(
                  isVisible: true,
                  position: LegendPosition.right,
                  alignment: ChartAlignment.center,
                  textStyle: const TextStyle(fontSize: 8.0, fontFamily: 'Jost'),
                  itemPadding: 0.0),
              series: <ChartSeries<_DummyTempSkatingData, String>>[
                FastLineSeries<_DummyTempSkatingData, String>(
                    dataSource: _data,
                    xValueMapper: (_DummyTempSkatingData data, _) => data.year,
                    yValueMapper: (_DummyTempSkatingData data, _) => data.score,
                    name: 'X',
                    width: 1),
                FastLineSeries<_DummyTempSkatingData, String>(
                    dataSource: _data2,
                    xValueMapper: (_DummyTempSkatingData data, _) => data.year,
                    yValueMapper: (_DummyTempSkatingData data, _) => data.score,
                    name: 'Y',
                    width: 1),
                FastLineSeries<_DummyTempSkatingData, String>(
                    dataSource: _data3,
                    xValueMapper: (_DummyTempSkatingData data, _) => data.year,
                    yValueMapper: (_DummyTempSkatingData data, _) => data.score,
                    name: 'Z',
                    width: 1),
              ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: IceButton(
              text: completePairing,
              onPressed: () {
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

  //TODO: Important to understand that this is always a new device, e.g. it isn't already in the users known device list
  //TODO: That check will have to be implemented

  //TODO: Maybe change for connection event when they will be done
  Future<void> _onDevicePressed(BluetoothDevice device) async {
    if (await _xSensDotConnectionService.connect(device)) {
      //TODO: await UserPreferenceManager().addDeviceToKnown(device.macAddress);
      setState(() {
        _connectionStep = 1;
      });
    }
    //TODO show error message (when I will have the UI model to do so)
  }
}

class _DummyTempSkatingData {
  _DummyTempSkatingData(this.year, this.score);

  final String year;
  final double score;
}
