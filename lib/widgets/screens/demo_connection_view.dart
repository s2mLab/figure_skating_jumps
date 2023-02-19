import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/services/x_sens_dot_channel_service.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/layout/topbar.dart';
import 'package:flutter/material.dart';

class DemoConnection extends StatefulWidget {
  const DemoConnection({Key? key}) : super(key: key);

  @override
  State<DemoConnection> createState() => _DemoConnectionState();
}

class _DemoConnectionState extends State<DemoConnection> {
  final XSensDotChannelService _xsensDotService = XSensDotChannelService();
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
                          child: const Text('get SDK Version'),
                        )),
                    IceButton(
                      onPressed: () async {
                        await _xsensDotService.startScan();
                      },
                      iceButtonImportance: IceButtonImportance.mainAction,
                      iceButtonSize: IceButtonSize.small,
                      color: primaryColor,
                      text: 'Start Scan',
                      textColor: paleText,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    GestureDetector(
                        onTap: () async {
                          List<dynamic> devices =
                              await _xsensDotService.stopScan();
                          for (dynamic dev in devices) {
                            setOutput("available device -> $dev");
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.green[300]),
                          child: const Text('Stop Scan'),
                        )),
                    GestureDetector(
                        onTap: () async {
                          setOutput(
                              "connection to : ${await _xsensDotService.connectXSensDot()}");
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 3),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blueGrey[300]),
                          child: const Text('Connect Xsens DOT'),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () async => _xsensDotService.startMeasuring(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.teal[200]),
                          child: const Text('Start Measurement'),
                        )),
                    GestureDetector(
                        onTap: () async => _xsensDotService.stopMeasuring(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.deepOrange[300]),
                          child: const Text('Stop Measurement'),
                        )),
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
