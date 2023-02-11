import 'dart:developer';

import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/widgets/screens/connection_dot_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // prevent phone rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: primaryBackground
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const xSensChannel = MethodChannel('xsens-dot-channel');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ConnectionDotView()),
                );
              },
              child: const Text('connection page')),
          TextButton(
              onPressed: () async {
                _exampleXsens();
              },
              child: const Text('SDK connection test'))
        ],
      )),
    );
  }

  _exampleXsens() async {
    String first;
    try {
      first = await xSensChannel
          .invokeMethod('exampleXSens', <String, dynamic>{'version': 'V1'});
    } on PlatformException catch (e) {
      log(e.message!);
      first = "1failed";
    }

    String second;
    try {
      second = await xSensChannel
          .invokeMethod('exampleXSens', <String, dynamic>{'version': 'V2'});
    } on PlatformException catch (e) {
      log(e.message!);
      second = "2failed";
    }

    String edge;
    try {
      edge = await xSensChannel
          .invokeMethod('exampleXSens', <String, dynamic>{'version': ''});
    } on PlatformException catch (e) {
      log(e.message!);
      edge = "3failed";
    }
    Fluttertoast.showToast(
      msg: ('$first $second $edge'),
      toastLength: Toast.LENGTH_LONG,
      fontSize: 18.0,
    );
  }
}
