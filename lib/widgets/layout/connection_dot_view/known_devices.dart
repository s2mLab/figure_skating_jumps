import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_state_subscriber.dart';
import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_bluetooth_discovery_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:flutter/material.dart';

import '../../../enums/x_sens_device_state.dart';
import '../../../interfaces/i_bluetooth_discovery_subscriber.dart';
import '../../../services/manager/bluetooth_device_manager.dart';
import '../../buttons/x_sens_dot_list_element.dart';
import '../../dialogs/xsens_management/configure_x_sens_dot_dialog.dart';
import '../../icons/x_sens_state_icon.dart';

class KnownDevices extends StatefulWidget {
  final Function refreshParentCallback;

  const KnownDevices({Key? key, required this.refreshParentCallback})
      : super(key: key);

  @override
  State<KnownDevices> createState() => _KnownDevicesState();
}

class _KnownDevicesState extends State<KnownDevices>
    implements IBluetoothDiscoverySubscriber, IXSensStateSubscriber {
  late XSensStateIcon _stateIconConnected;
  late XSensStateIcon _stateIconDisconnected;
  final List<BluetoothDevice> _knownDevices = [];
  final List<String> _scannedMacAddresses = [];
  final List<BluetoothDevice> _farDevices = [];
  final List<BluetoothDevice> _nearDevices = [];
  final XSensDotConnectionService _xSensDotConnectionService =
      XSensDotConnectionService();

  @override
  void initState() {
    _stateIconConnected =
        const XSensStateIcon(true, XSensDeviceState.connected);
    _stateIconDisconnected =
        const XSensStateIcon(true, XSensDeviceState.disconnected);

    _updateKnowDevices();

    XSensDotBluetoothDiscoveryService().subscribe(this);
    XSensDotConnectionService().subscribe(this);
    XSensDotBluetoothDiscoveryService().scanDevices();

    super.initState();
  }

  @override
  void dispose() {
    XSensDotConnectionService().unsubscribe(this);
    XSensDotBluetoothDiscoveryService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getWidthFromFactor(32)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (XSensDotConnectionService().currentXSensDevice != null)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                    child: Text(
                      connectedDevice,
                      style: TextStyle(color: primaryColorLight, fontSize: ReactiveLayoutHelper.getHeightFromFactor(20)),
                    ),
                  ),
                if (XSensDotConnectionService().currentXSensDevice != null)
                  Container(
                      margin: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                        child: XSensDotListElement(
                            hasLine: true,
                            lineColor: connectedXSensDotButtonIndicator,
                            text: XSensDotConnectionService()
                                .currentXSensDevice!
                                .name,
                            graphic: _stateIconConnected,
                            onPressed: () async {
                              await _onDevicePressed(XSensDotConnectionService()
                                  .currentXSensDevice);
                            }),
                      )),
                Container(
                  margin: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(16)),
                  child: Row(
                    children: [
                      Text(
                        knownDevicesNear,
                        style:
                            TextStyle(color: primaryColorLight, fontSize: ReactiveLayoutHelper.getHeightFromFactor(20)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: ReactiveLayoutHelper.getWidthFromFactor(16)),
                        child: SizedBox(
                          height: ReactiveLayoutHelper.getHeightFromFactor(20),
                          width: ReactiveLayoutHelper.getWidthFromFactor(20),
                          child: const CircularProgressIndicator(
                            color: discreetText,
                            value: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _nearDevices.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                          child: XSensDotListElement(
                            hasLine: true,
                            text: _nearDevices[index].name,
                            graphic: _stateIconDisconnected,
                            onPressed: () async {
                              await _onDevicePressed(_nearDevices[index]);
                            },
                          ));
                    }),
                Container(
                  margin: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(16)),
                  child: Text(
                    myDevices,
                    style: TextStyle(color: primaryColorLight, fontSize: ReactiveLayoutHelper.getHeightFromFactor(20)),
                  ),
                ),
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _farDevices.length,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                          child: XSensDotListElement(
                            hasLine: true,
                            text: _farDevices[index].name,
                            graphic: _stateIconDisconnected,
                            onPressed: () async {
                              await _onDevicePressed(_farDevices[index]);
                            },
                          ));
                    }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _filterNearDevices() {
    _nearDevices.clear();
    _nearDevices.addAll(_knownDevices
        .where((element) => _scannedMacAddresses.contains(element.macAddress)));
    if (_xSensDotConnectionService.currentXSensDevice != null) {
      _nearDevices.removeWhere((element) =>
          element.macAddress ==
          _xSensDotConnectionService.currentXSensDevice?.macAddress);
    }
  }

  void _filterFarDevices() {
    _farDevices.clear();
    _farDevices.addAll(_knownDevices.where(
        (element) => !_scannedMacAddresses.contains(element.macAddress)));
    if (_xSensDotConnectionService.currentXSensDevice != null) {
      _farDevices.removeWhere((element) =>
          element.macAddress ==
          _xSensDotConnectionService.currentXSensDevice?.macAddress);
    }
  }

  Future<void> _onDevicePressed(BluetoothDevice? device) async {
    if (device == null) return;
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConfigureXSensDotDialog(
            xSensDot: device,
            close: () {
              if (mounted) Navigator.of(context).pop();
              setState(() {
                _updateKnowDevices();
              });
              if (_knownDevices.isEmpty) {
                widget.refreshParentCallback();
              }
            },
          );
        });
    if (result == null) setState(() {});
  }

  void _updateKnowDevices() {
    if (_knownDevices.length != BluetoothDeviceManager().devices.length) {
      _knownDevices.clear();
      _knownDevices.addAll(BluetoothDeviceManager()
          .devices);
      _updateDeviceLists();
    }
  }

  void _updateDeviceLists() {
    _filterNearDevices();
    _filterFarDevices();
  }

  @override
  void onBluetoothDeviceListChange(List<BluetoothDevice> devices) {
    _scannedMacAddresses.clear();
    _scannedMacAddresses.addAll(devices.map((e) => e.macAddress));
    setState(() {
      _updateDeviceLists();
    });
  }

  @override
  void onStateChange(XSensDeviceState state) {
    setState(() {
      _updateDeviceLists();
    });
  }
}
