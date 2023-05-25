import 'dart:io';

import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/firebase_options.dart';
import 'package:figure_skating_jumps/services/camera_service.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/services/local_db/active_session_manager.dart';
import 'package:figure_skating_jumps/services/local_db/global_settings_manager.dart';
import 'package:figure_skating_jumps/services/local_db/local_db_service.dart';
import 'package:figure_skating_jumps/widgets/views/athlete_view.dart';
import 'package:figure_skating_jumps/widgets/views/capture_view.dart';
import 'package:figure_skating_jumps/widgets/views/coach_account_creation_view.dart';
import 'package:figure_skating_jumps/widgets/views/connection_dot_view.dart';
import 'package:figure_skating_jumps/widgets/views/edit_analysis_view.dart';
import 'package:figure_skating_jumps/widgets/views/forgot_password_view.dart';
import 'package:figure_skating_jumps/widgets/views/initial_redirect_route.dart';
import 'package:figure_skating_jumps/widgets/views/list_athletes_view.dart';
import 'package:figure_skating_jumps/widgets/views/login_view.dart';
import 'package:figure_skating_jumps/widgets/views/profile_view.dart';
import 'package:figure_skating_jumps/widgets/views/raw_data_view.dart';
import 'package:figure_skating_jumps/widgets/views/skater_creation_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  bool hasStoragePermissions = false;
  bool hasNetwork = false;

  WidgetsFlutterBinding.ensureInitialized();

  const xSensConnectionMethodChannel = MethodChannel('scan-method-channel');
  final coucou = await xSensConnectionMethodChannel.invokeMethod('startScan');
  debugPrint(coucou.toString());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var cameras = await availableCameras();
  if (cameras.isNotEmpty) CameraService().rearCamera = cameras.first;

  hasStoragePermissions = await initializeStoragePermissions();

  if (hasStoragePermissions) {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    hasNetwork = connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile;
  }

  if (hasNetwork) {
    await LocalDbService().ensureInitialized();

    await ActiveSessionManager().loadActiveSession();
    if (ActiveSessionManager().activeSession != null) {
      try {
        await UserClient().signIn(
            email: ActiveSessionManager().activeSession!.email,
            password: ActiveSessionManager().activeSession!.password);
      } catch (e) {
        ActiveSessionManager().clearActiveSession();
      }
    }

    await GlobalSettingsManager().loadSettings();
  }

  // prevent phone rotation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(FigureSkatingJumpApp(
      hasStoragePermissions: hasStoragePermissions,
      hasNetwork: hasNetwork,
      routeObserver: RouteObserver<ModalRoute<void>>()));
}

Future<bool> initializeStoragePermissions() async {
  bool permissionState = true;
  List<Permission> permissions = [];

  permissions.add(Permission.photos);
  if (Platform.isAndroid) {
    permissions.add(Permission.audio);
    permissions.add(Permission.videos);
  }
  permissions.add(Permission.camera);
  permissions.add(Permission.microphone);

  if (Platform.isIOS) permissions.add(Permission.storage);

  if (permissions.isNotEmpty) {
    (await permissions.request()).forEach((key, value) {
      if (!value.isGranted) {
        permissionState = false;
      }
    });
  }
  return permissionState;
}

class FigureSkatingJumpApp extends StatelessWidget {
  final bool hasStoragePermissions;
  final bool hasNetwork;
  final RouteObserver<ModalRoute<void>> routeObserver;

  const FigureSkatingJumpApp(
      {super.key,
      required this.hasStoragePermissions,
      required this.hasNetwork,
      required this.routeObserver});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figure Skating Jump App',
      initialRoute: '/InitialRedirectRoute',
      routes: {
        '/InitialRedirectRoute': (context) => InitialRedirectRoute(
            hasNetwork: hasNetwork,
            hasStoragePermissions: hasStoragePermissions),
        '/ManageDevices': (context) => const DeviceManagementView(),
        '/CoachAccountCreation': (context) => const CoachAccountCreationView(),
        '/CaptureData': (context) => const CaptureDataView(),
        '/Login': (context) => const LoginView(),
        '/CreateSkater': (context) => const SkaterCreationView(),
        '/Captures': (context) => const CapturesView(),
        '/EditAnalysis': (context) => const EditAnalysisView(),
        '/ListAthletes': (context) => const ListAthletesView(),
        '/Profile': (context) => const ProfileView(),
        '/RawData': (context) => RawDataView(routeObserver: routeObserver),
        '/ForgotPassword': (context) => ForgotPasswordView(),
      },
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: primaryBackground,
        fontFamily: 'Jost',
      ),
    );
  }
}
