import 'dart:async';

import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../layout/topbar.dart';

class RawDataView extends StatelessWidget {
  const RawDataView({super.key, required this.logStream});
  final Stream<String> logStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(isUserDebuggingFeature: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(rawDataTitle,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: InstructionPrompt(warnRawDataPrompt, secondaryColor),
          ),
          _LoggerView(logStream: logStream)
        ]),
      ),
    );
  }
}

class _LoggerView extends StatefulWidget {
  final Stream<String> logStream;

  const _LoggerView({required this.logStream, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoggerViewState();
}

class _LoggerViewState extends State<_LoggerView> {
  final List<String> _logs = [];
  final ScrollController _scrollController = ScrollController();
  late final StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();
    // TODO: remove placeholder long value
    _logs.add(
        'vaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    // Adds logs as they arrive to the _logs list so that
    // they'd be displayed by the ListView.builder
    _subscription = widget.logStream.listen((log) {
      setState(() {
        _logs.add(log);
      });
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100), curve: Curves.easeOut);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _subscription?.cancel();
        return Future.value(true);
      },
      child: Expanded(
        child: Container(
            color: Colors.black,
            width: double.infinity,
            child: ListView.builder(
                controller: _scrollController,
                itemCount: _logs.length,
                itemBuilder: (context, i) {
                  return Text(_logs[i],
                      style: const TextStyle(
                          fontSize: 10,
                          color: paleText,
                          fontFamily: 'monospace'));
                })),
      ),
    );
  }
}
