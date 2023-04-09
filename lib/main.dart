import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';
import 'package:figure_skating_jumps/services/manager/active_session_manager.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/widgets/views/athlete_view.dart';
import 'package:figure_skating_jumps/widgets/views/capture_view.dart';
import 'package:figure_skating_jumps/widgets/views/coach_account_creation_view.dart';
import 'package:figure_skating_jumps/widgets/views/connection_dot_view.dart';

import 'package:figure_skating_jumps/widgets/views/edit_analysis_view.dart';
import 'package:figure_skating_jumps/widgets/views/forgot_password_view.dart';
import 'package:figure_skating_jumps/widgets/views/initial_redirect_route.dart';
import 'package:figure_skating_jumps/widgets/views/list_athletes_view.dart';
import 'package:figure_skating_jumps/widgets/views/login_view.dart';
import 'package:figure_skating_jumps/widgets/views/missing_permissions_view.dart';
import 'package:figure_skating_jumps/widgets/views/profile_view.dart';
import 'package:figure_skating_jumps/widgets/views/skater_creation_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'firebase_options.dart';
import 'package:camera/camera.dart';

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
  await ActiveSessionManager().loadActiveSession();
  if (ActiveSessionManager().activeSession != null) {
    await UserClient().signIn(
        email: ActiveSessionManager().activeSession!.email,
        password: ActiveSessionManager().activeSession!.password);
  }

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

  if ((await MediaStore().getPlatformSDKInt()) <= 32) {
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
    return MaterialApp(
      title: 'Figure Skating Jump App',
      initialRoute: '/InitialRedirectRoute',
      routes: {
        '/InitialRedirectRoute': (context) => InitialRedirectRoute(canFunction),
        '/ManageDevices': (context) => const ConnectionDotView(),
        '/CoachAccountCreation': (context) => const CoachAccountCreationView(),
        '/CaptureData': (context) => const CaptureView(),
        '/Login': (context) => const LoginView(),
        '/CreateSkater': (context) => const SkaterCreationView(),
        '/Acquisitions': (context) => const AthleteView(),
        '/EditAnalysis': (context) => const EditAnalysisView(),
        '/ListAthletes': (context) => const ListAthletesView(),
        '/ProfileView': (context) => const ProfileView(),
        '/ForgotPasswordView': (context) => ForgotPasswordView(),
        '/MissingPermissions': (context) => const MissingPermissionsView(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBackground,
        fontFamily: 'Jost',
      ),
    );
  }
}
