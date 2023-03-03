import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/widgets/layout/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/topbar.dart';
import 'package:figure_skating_jumps/widgets/screens/capture_view.dart';
import 'package:figure_skating_jumps/widgets/screens/coach_account_creation_view.dart';
import 'package:figure_skating_jumps/widgets/screens/connection_dot_view.dart';
import 'package:figure_skating_jumps/widgets/screens/demo_connection_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var cameras = await availableCameras();
  CameraService().rearCamera = cameras.first;
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
        '/': (context) => const GodView(),
        '/ManageDevices': (context) => const ConnectionDotView(),
        '/DemoConnection': (context) => const DemoConnection(),
        '/CoachAccountCreation': (context) => const CoachAccountCreationView(),
        '/CaptureData': (context) => const CaptureView(),
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

class GodView extends StatefulWidget {
  const GodView({super.key});

  @override
  State<GodView> createState() => _GodViewState();
}

class _GodViewState extends State<GodView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Topbar(isUserDebuggingFeature: true),
      drawer: const IceDrawerMenu(isUserDebuggingFeature: true),
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
                Navigator.pushNamed(
                  context,
                  '/ManageDevices',
                );
              },
              child: const Text('ConnectionDotView')),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/CaptureData',
                );
              },
              child: const Text('CaptureView')),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/DemoConnection',
                );
              },
              child: const Text('Demo XSensDot')),
          TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/CoachAccountCreation',
                );
              },
              child: const Text('CoachAccountCreation')),
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
        ],
      )),
    );
  }
}
