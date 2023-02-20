import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/widgets/layout/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/topbar.dart';
import 'package:figure_skating_jumps/widgets/screens/connection_dot_view.dart';
import 'package:figure_skating_jumps/widgets/screens/demo_connection_view.dart';
import 'package:figure_skating_jumps/widgets/screens/raw_data_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
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
      title: 'Figure Skating Jump App',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
        '/ManageDevices': (context) => const ConnectionDotView(),
        //'/RawData': (context) => const RawDataView(logStream: logStream), TODO : decouple logStream to an external service
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBackground,
        fontFamily: 'Jost',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(isUserDebuggingFeature: true),
      drawer: const IceDrawerMenu(),
      body: Center(
          child: Column(
        children: [
          const Text('Navigation Dieu',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold)),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DemoConnection()),
                );
              },
              child: const Text('Demo XSensDot')),
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
}
