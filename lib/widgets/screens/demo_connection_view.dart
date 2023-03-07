import 'package:figure_skating_jumps/models/bluetooth_device.dart';
import 'package:figure_skating_jumps/services/x_sens_dot_channel_service.dart';
import 'package:figure_skating_jumps/widgets/layout/topbar.dart';
import 'package:flutter/material.dart';

class DemoConnection extends StatefulWidget {
  const DemoConnection({Key? key}) : super(key: key);

  @override
  State<DemoConnection> createState() => _DemoConnectionState();
}

class _DemoConnectionState extends State<DemoConnection> {
  final XSensDotChannelService _xsensDotService = XSensDotChannelService();
  List<String> outputRate = ["10", "20", "30", "60"];
  late String selectedRate = outputRate.last;
  List<String> outputText = [];

  setOutput(String text) {
    setState(() {
      outputText.insert(0, text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightGreen[100],
        appBar: const Topbar(isUserDebuggingFeature: true),
        body: Container(
            margin: const EdgeInsets.all(30),
            child: Column(
              children: [
                const Text(
                  'Demo Connection',
                  style: TextStyle(fontSize: 26),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          setOutput(await _xsensDotService.getSDKVersion());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red[200]),
                          child: const Text('Get SDK Version'),
                        )),
                    GestureDetector(
                        onTap: () async {
                          await _xsensDotService.startScan();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green[200]),
                          child: const Text('Start Scan'),
                        )),
                    GestureDetector(
                        onTap: () async {
                          List<dynamic> devices =
                              await _xsensDotService.stopScan();
                          for (BluetoothDevice dev in devices) {
                            setOutput("available device -> ${dev.macAddress}");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.pink[200]),
                          child: const Text('Stop Scan'),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () async {
                          setOutput(
                              "connection to : ${await _xsensDotService.connectXSensDot(macAddress: 'D4:22:CD:00:14:0E')}");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blueGrey[300]),
                          child: const Text('Connect Xsens DOT'),
                        )),
                    GestureDetector(
                        onTap: () async => await _xsensDotService.startMeasuring(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.teal[200]),
                          child: const Text('Start'),
                        )),
                    GestureDetector(
                        onTap: () async => await _xsensDotService.stopMeasuring(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.deepOrange[300]),
                          child: const Text('Stop'),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DropdownButton<String>(
                      value: selectedRate,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? value) {},
                      items: outputRate
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: Container(
                  width: 500,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5)),
                  child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(outputText.length, (index) {
                            return Text(
                              outputText[index],
                              style: const TextStyle(color: Colors.white),
                            );
                          }))),
                ))
              ],
            )));
  }
}
