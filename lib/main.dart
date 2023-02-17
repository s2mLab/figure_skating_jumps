import 'dart:developer';

import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/widgets/screens/connection_dot_view.dart';
import 'package:figure_skating_jumps/widgets/screens/raw_data_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:figure_skating_jumps/services/user_client.dart';

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
        scaffoldBackgroundColor: primaryBackground,
        fontFamily: 'Jost',
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
      appBar: AppBar(title: const Center(child: Text("God Navigation Page"))),
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
              child: const Text('ConnectionDotView')),
          TextButton(
              onPressed: () async {
                UserClient().signUp('gary@gary.com', 'A1b!78p',
                    SkatingUser('gary', 'gary', UserRole.coach));
              },
              child: const Text('Sign up test')),
          TextButton(
              onPressed: () async {
                UserClient().signIn('gary@gary.com', 'A1b!78p');
                UserClient().signOut();
              },
              child: const Text('Sign in test')),
          TextButton(
              onPressed: () async => _getSDKVersion(),
              child: const Text('getSDKVersion')),
          TextButton(
              onPressed: () async => _getCloseXsensDot(),
              child: const Text('getCloseXsensDot')),
          TextButton(
              onPressed: () async => _connectXsensDot(),
              child: const Text('connectXsenDot')),
          TextButton(
              onPressed: () async => _startMeasuring(),
              child: const Text('START')),
          TextButton(
              onPressed: () async => _stopmeasuring(),
              child: const Text('STOP')),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      // TODO: remove periodic stream and instantiate with xsensdot device datastream
                      builder: (context) => RawDataView(
                            logStream: Stream.periodic(
                              const Duration(milliseconds: 300),
                              (count) => 'Log entry $count',
                            ).take(50),
                          )),
                );
              },
              child: const Text('Raw data test')),
        ],
      )),
    );
  }

  _getSDKVersion() async {
    try {
      debugPrint("1");
      debugPrint(await xSensChannel.invokeMethod('getSDKVersion'));
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  _getCloseXsensDot() async {
    try {
      debugPrint("2");
      debugPrint(await xSensChannel.invokeMethod('getCloseXsensDot'));
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  _connectXsensDot() async {
    try {
      debugPrint("3");
      debugPrint((await xSensChannel.invokeMethod('connectXsensDot',
              <String, dynamic>{'address': 'D4:22:CD:00:19:F4'}))
          .toString());
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  _startMeasuring() async {
    try {
      debugPrint("4");
      debugPrint(await xSensChannel.invokeMethod('startMeasuring'));
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }

  _stopmeasuring() async {
    try {
      debugPrint("5");
      debugPrint(await xSensChannel.invokeMethod('stopMeasuring'));
    } on PlatformException catch (e) {
      debugPrint(e.message!);
    }
  }
}
