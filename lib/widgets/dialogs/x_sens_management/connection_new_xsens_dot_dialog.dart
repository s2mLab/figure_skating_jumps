import 'dart:async';

import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/x_sens/x_sens_device_state.dart';
import 'package:figure_skating_jumps/interfaces/i_bluetooth_discovery_subscriber.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_dot_streaming_data_subscriber.dart';
import 'package:figure_skating_jumps/models/local_db/bluetooth_device.dart';
import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';
import 'package:figure_skating_jumps/services/local_db/bluetooth_device_manager.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_bluetooth_discovery_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_streaming_data_service.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
import 'package:figure_skating_jumps/widgets/icons/x_sens_state_icon.dart';
import 'package:figure_skating_jumps/widgets/layout/instruction_prompt.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      insetPadding: EdgeInsets.symmetric(
          horizontal: ReactiveLayoutHelper.getWidthFromFactor(16, true),
          vertical: ReactiveLayoutHelper.getHeightFromFactor(104)),
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
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(
                    ReactiveLayoutHelper.getHeightFromFactor(16)),
                child: Text(
                  newXSensConnectionDialogTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: paleText,
                      fontSize: ReactiveLayoutHelper.getHeightFromFactor(20)),
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
        Padding(
          padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
          child: const InstructionPrompt(
              bluetoothAuthorizationPromptInfo, secondaryColor),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: ReactiveLayoutHelper.getHeightFromFactor(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    right: ReactiveLayoutHelper.getWidthFromFactor(16)),
                child: SizedBox(
                  height: ReactiveLayoutHelper.getHeightFromFactor(20),
                  width: ReactiveLayoutHelper.getHeightFromFactor(20),
                  child: const CircularProgressIndicator(
                    color: primaryColorDark,
                    value: null,
                  ),
                ),
              ),
              Text(searchingLabel,
                  style: TextStyle(
                      fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)))
            ],
          ),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(20)),
          child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: ReactiveLayoutHelper.getHeightFromFactor(16)),
                  child: XSensDotListElement(
                    hasLine: true,
                    text: _devices[index].name,
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
          padding: EdgeInsets.only(
              bottom: ReactiveLayoutHelper.getHeightFromFactor(16)),
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
        Padding(
          padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
          child: const Center(
              child: XSensStateIcon(false, XSensDeviceState.connecting)),
        ),
        Padding(
          padding:
              EdgeInsets.only(left: ReactiveLayoutHelper.getWidthFromFactor(8)),
          child:
              const InstructionPrompt(verifyConnectivityLabel, secondaryColor),
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
                      textStyle: TextStyle(
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(12.0),
                          fontFamily: 'Jost'),
                      alignment: ChartAlignment.near),
                  // Enable legend
                  legend: Legend(
                      isVisible: true,
                      position: LegendPosition.right,
                      alignment: ChartAlignment.center,
                      textStyle: TextStyle(
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(8.0),
                          fontFamily: 'Jost'),
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
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getHeightFromFactor(8)),
                child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    noDataLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Jost',
                        fontSize:
                            ReactiveLayoutHelper.getHeightFromFactor(16)),
                  ),
                  const CircularProgressIndicator()
                ],
                  ),
              ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: ReactiveLayoutHelper.getHeightFromFactor(16)),
          child: IceButton(
              text: completePairingButton,
              onPressed: () async {
                try {
                  await BluetoothDeviceManager().addDevice(
                      _xSensDotConnectionService.currentXSensDevice!);
                } catch (e) {
                  Fluttertoast.showToast(msg: pairErrorLabel);
                }

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
          padding: EdgeInsets.only(
              bottom: ReactiveLayoutHelper.getHeightFromFactor(16)),
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

  /// This function is called when the list of Bluetooth devices changes. It updates the state
  /// of the component by calling _addScannedDevices which adds the new devices to the list of
  /// devices to be displayed.
  ///
  /// Parameters:
  /// - [devices] : The new list of Bluetooth devices.
  @override
  void onBluetoothDeviceListChange(List<BluetoothDevice> devices) {
    if (mounted) {
      setState(() {
        _addScannedDevices(devices);
      });
    }
  }

  /// Connects to the given Bluetooth device and starts streaming data from it. Displays a connection
  /// error message and logs a message to the console if the connection fails.
  ///
  /// Parameters:
  /// - [device]: The Bluetooth device to connect to.
  ///
  /// Return:
  /// - Future<void>: A Future that completes when the connection and data streaming have been started.
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

  /// Clears the existing device list, and adds any scanned devices that are not already in the list.
  ///
  /// Parameters:
  /// - [scannedDevices]: a list of [BluetoothDevice] objects to be added
  void _addScannedDevices(List<BluetoothDevice> scannedDevices) {
    _devices.clear();
    List<String> knownMacAddresses = [];
    knownMacAddresses
        .addAll(BluetoothDeviceManager().devices.map((e) => e.macAddress));
    Iterable<BluetoothDevice> devicesToAdd = scannedDevices.where(
        (scannedDevice) =>
            !knownMacAddresses.contains(scannedDevice.macAddress));
    _devices.addAll(devicesToAdd);
  }

  /// This function updates the [_streamedData] list with the newly measured data, and updates
  /// the data sources of the x, y and z [SfCartesianChart] series controllers with any new data
  /// that was added to the [_streamedData] list.
  ///
  /// Parameters:
  /// - [measuredData]: a list of [XSensDotData] objects that represent the newly measured data.
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
