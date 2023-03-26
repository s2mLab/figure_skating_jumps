import 'dart:math';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/views/athlete_view.dart';
import 'package:figure_skating_jumps/widgets/views/capture_view.dart';
import 'package:figure_skating_jumps/widgets/views/coach_account_creation_view.dart';
import 'package:figure_skating_jumps/widgets/views/connection_dot_view.dart';
import 'package:figure_skating_jumps/widgets/views/demo_connection_view.dart';

import 'package:figure_skating_jumps/widgets/views/edit_analysis_view.dart';
import 'package:figure_skating_jumps/widgets/views/list_athletes_view.dart';
import 'package:figure_skating_jumps/widgets/views/login_view.dart';
import 'package:figure_skating_jumps/widgets/views/skater_creation_view.dart';
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

  var cameras = await availableCameras();
  CameraService().rearCamera = cameras.first;

  hasNecessaryPermissions = await initializeStoragePermissions();

  await LocalDbService().ensureInitialized();

  // prevent phone rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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

  if((await MediaStore().getPlatformSDKInt()) <= 32) {
    permissions.add(Permission.storage);
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
    return canFunction
        ? MaterialApp(
            title: 'Figure Skating Jump App',
            initialRoute: '/Login',
            routes: {
              '/': (context) => const GodView(),
              '/ManageDevices': (context) => const ConnectionDotView(),
              '/DemoConnection': (context) => const DemoConnection(),
              '/CoachAccountCreation': (context) =>
                  const CoachAccountCreationView(),
              '/CaptureData': (context) => const CaptureView(),
              '/Login': (context) => const LoginView(),
              '/CreateSkater': (context) => const SkaterCreationView(),
              '/Acquisitions': (context) => const AthleteView(),
              '/EditAnalysis': (context) => const EditAnalysisView(),
              '/ListAthletes': (context) => const ListAthletesView(),
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
      drawerScrimColor: Colors.transparent,
      drawerEnableOpenDragGesture: false,
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
                // This line is temp. Eventually user will already be logged in. Remove async then.
                await UserClient()
                    .signIn(email: 'thomc@thomc.com', password: 'thomc123456');
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, '/ListAthletes');
              },
              child: const Text('List Athletes')),
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
                Jump jump = Jump(rnd.nextInt(6000), rnd.nextInt(1500),
                    JumpType.values[rnd.nextInt(5)], "Good", 5,"TT9qrmqIdRfJGrlTzo7g", 3000.0, 1100.0, 780.0);
                CaptureClient().createJump(jump: jump);
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
