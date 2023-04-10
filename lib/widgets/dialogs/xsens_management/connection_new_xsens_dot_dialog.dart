import 'dart:async';

import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';
import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_dot_streaming_data_subscriber.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:figure_skating_jumps/services/manager/device_names_manager.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_bluetooth_discovery_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_streaming_data_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';

class ConnectionNewXSensDotDialog extends StatefulWidget {
  const ConnectionNewXSensDotDialog({super.key});

  @override
  State<ConnectionNewXSensDotDialog> createState() =>
      _ConnectionNewXSensDotState();
}

class _ConnectionNewXSensDotState extends State<ConnectionNewXSensDotDialog>
    implements IBluetoothDiscoverySubscriber, IXSensDotMeasuringDataSubscriber {
  int _connectionStep = 0;
  final List<BluetoothDevice> _devices = [];
  final List<XSensDotData> _streamedData = [];
  ChartSeriesController? _xChartSeriesController;
  ChartSeriesController? _yChartSeriesController;
  ChartSeriesController? _zChartSeriesController;
  final XSensDotBluetoothDiscoveryService _discoveryService =
      XSensDotBluetoothDiscoveryService();
  final XSensDotConnectionService _xSensDotConnectionService =
      XSensDotConnectionService();
  final XSensDotStreamingDataService _xSensDotStreamingDataService =
      XSensDotStreamingDataService();

  @override
  void initState() {
    _addScannedDevices(_discoveryService.subscribe(this));
    _streamedData.addAll(_xSensDotStreamingDataService.subscribe(this));
    _discoveryService.scanDevices();
    super.initState();
  }

  @override
  void dispose() {
    _xSensDotStreamingDataService.unsubscribe(this);
    _discoveryService.unsubscribe(this);
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
          child: InstructionPrompt(
              bluetoothAuthorizationPromptInfo, secondaryColor),
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
              Text(searchingLabel)
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
              text: cancelLabel,
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
          child: InstructionPrompt(verifyConnectivityLabel, secondaryColor),
        ),
        Expanded(
          child: _streamedData.isNotEmpty
              ? SfCartesianChart(
                  primaryXAxis: NumericAxis(),
                  primaryYAxis: NumericAxis(
                      decimalPlaces: 2, rangePadding: ChartRangePadding.round),
                  // Chart title
                  title: ChartTitle(
                      text: dataChartTitle,
                      textStyle:
                          const TextStyle(fontSize: 12.0, fontFamily: 'Jost'),
                      alignment: ChartAlignment.near),
                  // Enable legend
                  legend: Legend(
                      isVisible: true,
                      position: LegendPosition.right,
                      alignment: ChartAlignment.center,
                      textStyle:
                          const TextStyle(fontSize: 8.0, fontFamily: 'Jost'),
                      itemPadding: 0.0),
                  series: <ChartSeries<XSensDotData, int>>[
                      FastLineSeries<XSensDotData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _xChartSeriesController = controller;
                          },
                          dataSource: _streamedData,
                          xValueMapper: (XSensDotData data, _) => data.id,
                          yValueMapper: (XSensDotData data, _) => data.acc[0],
                          name: firstFastLineName,
                          width: 1),
                      FastLineSeries<XSensDotData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _yChartSeriesController = controller;
                          },
                          dataSource: _streamedData,
                          xValueMapper: (XSensDotData data, _) => data.id,
                          yValueMapper: (XSensDotData data, _) => data.acc[1],
                          name: secondFastLineName,
                          width: 1),
                      FastLineSeries<XSensDotData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _zChartSeriesController = controller;
                          },
                          dataSource: _streamedData,
                          xValueMapper: (XSensDotData data, _) => data.id,
                          yValueMapper: (XSensDotData data, _) => data.acc[2],
                          name: lastFastLineName,
                          width: 1),
                    ])
              : const Center(
                  child: Text(
                  noDataLabel,
                  style: TextStyle(fontFamily: 'Jost'),
                )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: IceButton(
              text: completePairingButton,
              onPressed: () async {
                await _xSensDotStreamingDataService.stopMeasuring();
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              textColor: paleText,
              color: confirm,
              iceButtonImportance: IceButtonImportance.mainAction,
              iceButtonSize: IceButtonSize.large),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: IceButton(
              text: cancelLabel,
              onPressed: () async {
                await _xSensDotStreamingDataService.stopMeasuring();
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
        _addScannedDevices(devices);
      });
    }
  }

  Future<void> _onDevicePressed(BluetoothDevice device) async {
    _streamedData.clear();
    if (await _xSensDotConnectionService.connect(device)) {
      setState(() {
        _connectionStep = 1;
      });
      await _xSensDotStreamingDataService
          .startMeasuring(XSensDotConnectionService().isInitialized);
    } else {
      Fluttertoast.showToast(msg: connectionErrorLabel + device.macAddress);
      debugPrint("Connection to device ${device.macAddress} failed");
    }
  }

  void _addScannedDevices(List<BluetoothDevice> scannedDevices) {
    _devices.clear();
    List<String> knownMacAddresses = [];
    knownMacAddresses.addAll(
        DeviceNamesManager().deviceNames.map((e) => e.deviceMacAddress));
    Iterable<BluetoothDevice> devicesToAdd = scannedDevices.where(
        (scannedDevice) =>
            !knownMacAddresses.contains(scannedDevice.macAddress));
    _devices.addAll(devicesToAdd);
  }

  @override
  void onDataReceived(List<XSensDotData> measuredData) {
    if (_streamedData.isEmpty) {
      if (mounted) {
        setState(() {
          _streamedData.addAll(measuredData);
        });
      }
    } else {
      if (_xChartSeriesController == null ||
          _yChartSeriesController == null ||
          _zChartSeriesController == null) return;

      int startIndex = _streamedData.length;
      int nbAddedData = measuredData.length - _streamedData.length;
      List<int> addedIndexes =
          List<int>.generate(nbAddedData, (i) => i + startIndex);

      _streamedData.addAll(
          measuredData.where((element) => !_streamedData.contains(element)));

      _xChartSeriesController?.updateDataSource(addedDataIndexes: addedIndexes);
      _yChartSeriesController?.updateDataSource(addedDataIndexes: addedIndexes);
      _zChartSeriesController?.updateDataSource(addedDataIndexes: addedIndexes);
    }
  }
}
