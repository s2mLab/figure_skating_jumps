import 'dart:async';

import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_dot_streaming_data_subscriber.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_channel_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_data_service.dart';
import 'package:figure_skating_jumps/widgets/layout/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../layout/topbar.dart';

class RawDataView extends StatelessWidget {
  const RawDataView({super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(isUserDebuggingFeature: true),
      drawer: const IceDrawerMenu(isUserDebuggingFeature: true),
      drawerScrimColor: Colors.transparent,
      drawerEnableOpenDragGesture: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text(rawDataTitle,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: InstructionPrompt(warnRawDataPrompt, secondaryColor),
          ),
          _LoggerView()
        ]),
      ),
    );
  }
}

class _LoggerView extends StatefulWidget {

  const _LoggerView({Key? key }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<_LoggerView> implements IXSensDotMeasuringDataSubscriber {
  final ScrollController _scrollController = ScrollController();
  late List<XSensDotData> _displayedData;

  @override
  void initState() {
    super.initState();
    XSensDotChannelService().startMeasuring();
    _displayedData = XSensDotDataService().subscribe(this);
  }

  @override
  void dispose() {
    XSensDotChannelService().stopMeasuring();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            color: Colors.black,
            width: double.infinity,
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _displayedData.length,
                itemBuilder: (context, i) {
                  return Text(_displayedData[i].toString(),
                      style: const TextStyle(
                          fontSize: 5,
                          color: paleText,
                          fontFamily: 'monospace'));
                })),
      );
  }

  @override
  void onDataReceived(List<XSensDotData> measuredData) {
    if (mounted) {
      setState(() {
        _displayedData = measuredData;
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
      });
    }
  }
}
