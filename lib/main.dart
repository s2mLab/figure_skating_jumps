import 'dart:math';

import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';
import 'package:figure_skating_jumps/widgets/layout/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/topbar.dart';
import 'package:figure_skating_jumps/widgets/screens/capture_view.dart';
import 'package:figure_skating_jumps/widgets/screens/coach_account_creation_view.dart';
import 'package:figure_skating_jumps/widgets/screens/connection_dot_view.dart';
import 'package:figure_skating_jumps/widgets/screens/demo_connection_view.dart';
import 'package:figure_skating_jumps/widgets/screens/login_view.dart';
import 'package:figure_skating_jumps/widgets/screens/skater_creation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:camera/camera.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';

Future<void> main() async {
  bool hasNecessaryPermissions = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  hasNecessaryPermissions = await initializeStoragePermissions();
  var cameras = await availableCameras();
  CameraService().rearCamera = cameras.first;
  await LocalDbService().ensureInitialized();
  runApp(FigureSkatingJumpApp(canFunction: hasNecessaryPermissions));
}

Future<bool> initializeStoragePermissions() async {
  bool permissionState = true;
  List<Permission> permissions = [];

  if ((await MediaStore().getPlatformSDKInt()) >= 33) {
    permissions.add(Permission.photos);
    permissions.add(Permission.audio);
    permissions.add(Permission.videos);
  }

  if (permissions.isNotEmpty) {
    (await permissions.request()).forEach((key, value) {
      if (!value.isGranted) {
        permissionState = false;
      }
    });
  }
  return Future<bool>.value(permissionState);
}

class FigureSkatingJumpApp extends StatelessWidget {
  final bool canFunction;
  const FigureSkatingJumpApp({super.key, required this.canFunction});

  @override
  Widget build(BuildContext context) {
    // prevent phone rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return canFunction
        ? MaterialApp(
            title: 'Figure Skating Jump App',
            initialRoute: '/',
            routes: {
              '/': (context) => const GodView(),
              '/ManageDevices': (context) => const ConnectionDotView(),
              '/DemoConnection': (context) => const DemoConnection(),
              '/CoachAccountCreation': (context) =>
                  const CoachAccountCreationView(),
              '/CaptureData': (context) => const CaptureView(),
              '/Login': (context) => const LoginView(),
              '/CreateSkater': (context) => const SkaterCreationView(),
            },
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: primaryBackground,
              fontFamily: 'Jost',
            ),
          )
        : MaterialApp(
            title: 'Figure Skating Jump App',
            builder: (context, _) {
              return const Text("Veuillez autoriser les permissions.");
            },
          ); //TODO: Placeholder until we have UI to handle the case when no permissions are granted.
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
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/CreateSkater',
                );
              },
              child: const Text('CreateSkaterUI')),
          TextButton(
              onPressed: () async {
                UserClient()
                    .signIn(email: 'gary@gary.com', password: 'abcdef12345');
              },
              child: const Text('Sign in test')),
          TextButton(
              onPressed: () async {
                UserClient().signOut();
              },
              child: const Text('Sign out test')),
          TextButton(
              onPressed: () async {
                UserClient().delete();
              },
              child: const Text('Delete user test')),
          TextButton(
              onPressed: () async {
                Random rnd = Random();
                Jump jump = Jump(rnd.nextInt(6000), rnd.nextInt(1500), 10,
                    JumpType.axel, "TT9qrmqIdRfJGrlTzo7g");
                CaptureClient().addJump(jump: jump);
              },
              child: const Text('Make Him JUMP!')),
          TextButton(
              onPressed: () async {
                UserClient().addSkater(
                    skaterId: "BNegDj2K1ubkEQ4bb4okGQyrL0O2",
                    coachId: "SDlOvaQOGKMKTKiTTeyvNr9SaVA3");
              },
              child: const Text('Add Skater')),
          TextButton(
              onPressed: () async {
                UserClient().removeSkater(
                    skaterId: "BNegDj2K1ubkEQ4bb4okGQyrL0O2",
                    coachId: "SDlOvaQOGKMKTKiTTeyvNr9SaVA3");
              },
              child: const Text('Remove Skater')),
        ],
      )),
    );
  }
}
