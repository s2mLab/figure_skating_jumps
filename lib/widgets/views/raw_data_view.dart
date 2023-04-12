import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_dot_streaming_data_subscriber.dart';
import 'package:figure_skating_jumps/models/xsens_dot_data.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_streaming_data_service.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../utils/reactive_layout_helper.dart';
import '../layout/scaffold/tablet_topbar.dart';
import '../layout/scaffold/topbar.dart';

class RawDataView extends StatelessWidget {
  const RawDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReactiveLayoutHelper.isTablet() ? const TabletTopbar(isUserDebuggingFeature: true) as PreferredSizeWidget : const Topbar(isUserDebuggingFeature: true),
      drawer: const IceDrawerMenu(isUserDebuggingFeature: true),
      drawerScrimColor: Colors.transparent,
      drawerEnableOpenDragGesture: false,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(16), horizontal: ReactiveLayoutHelper.getWidthFromFactor(32, true)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageTitle(text: rawDataTitle),
              Padding(
                padding: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(24)),
                child: const InstructionPrompt(warnRawDataPromptInfo, secondaryColor),
              ),
              const _LoggerView()
            ]),
      ),
    );
  }
}

class _LoggerView extends StatefulWidget {
  const _LoggerView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<_LoggerView>
    implements IXSensDotMeasuringDataSubscriber {
  final ScrollController _scrollController = ScrollController();
  late List<XSensDotData> _displayedData;

  @override
  void initState() {
    super.initState();
    XSensDotStreamingDataService()
        .startMeasuring(XSensDotConnectionService().isInitialized);
    _displayedData = XSensDotStreamingDataService().subscribe(this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    XSensDotStreamingDataService().stopMeasuring();
    XSensDotStreamingDataService().unsubscribe(this);
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
                    style: TextStyle(
                        fontSize: ReactiveLayoutHelper.getHeightFromFactor(5), color: paleText, fontFamily: 'monospace'));
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
