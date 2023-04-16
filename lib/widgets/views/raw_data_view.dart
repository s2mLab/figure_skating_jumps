import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/interfaces/i_x_sens_dot_streaming_data_subscriber.dart';
import 'package:figure_skating_jumps/models/x_sens_dot_data.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_connection_service.dart';
import 'package:figure_skating_jumps/services/x_sens/x_sens_dot_streaming_data_service.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/tablet_topbar.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/layout/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

class RawDataView extends StatelessWidget {
  final RouteObserver<ModalRoute<void>> routeObserver;
  const RawDataView({super.key, required this.routeObserver});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReactiveLayoutHelper.isTablet()
          ? const TabletTopbar(isUserDebuggingFeature: true)
              as PreferredSizeWidget
          : const Topbar(isUserDebuggingFeature: true),
      drawer: const IceDrawerMenu(isUserDebuggingFeature: true),
      drawerScrimColor: Colors.transparent,
      drawerEnableOpenDragGesture: false,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: ReactiveLayoutHelper.getHeightFromFactor(16),
            horizontal: ReactiveLayoutHelper.getWidthFromFactor(32, true)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const PageTitle(text: rawDataTitle),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: ReactiveLayoutHelper.getHeightFromFactor(24)),
            child:
                const InstructionPrompt(warnRawDataPromptInfo, secondaryColor),
          ),
          _LoggerView(
            routeObserver: routeObserver,
          )
        ]),
      ),
    );
  }
}

class _LoggerView extends StatefulWidget {
  final RouteObserver<ModalRoute<void>> routeObserver;
  const _LoggerView({Key? key, required this.routeObserver}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<_LoggerView>
    with RouteAware
    implements IXSensDotMeasuringDataSubscriber {
  final ScrollController _scrollController = ScrollController();
  late List<XSensDotData> _displayedData;
  final XSensDotStreamingDataService _xSensDotStreamingDataService =
      XSensDotStreamingDataService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _startStreaming();
    super.didPush();
  }

  @override
  void didPushNext() {
    _stopStreaming();
    super.didPush();
  }

  @override
  void didPop() {
    _stopStreaming();
    super.didPopNext();
  }

  @override
  void didPopNext() {
    _startStreaming();
    super.didPopNext();
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
                        fontSize: ReactiveLayoutHelper.getHeightFromFactor(5),
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

  void _startStreaming() {
    XSensDotStreamingDataService()
        .startMeasuring(XSensDotConnectionService().isInitialized);
    _displayedData = _xSensDotStreamingDataService.subscribe(this);
  }

  void _stopStreaming() {
    _xSensDotStreamingDataService.stopMeasuring();
    _xSensDotStreamingDataService.unsubscribe(this);
  }
}
