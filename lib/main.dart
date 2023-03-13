import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/local_db_service.dart';
import 'package:figure_skating_jumps/widgets/layout/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/topbar.dart';
import 'package:figure_skating_jumps/widgets/screens/acquisitions_view.dart';
import 'package:figure_skating_jumps/widgets/screens/coach_account_creation_view.dart';
import 'package:figure_skating_jumps/widgets/screens/connection_dot_view.dart';
import 'package:figure_skating_jumps/widgets/screens/demo_connection_view.dart';
import 'package:figure_skating_jumps/widgets/screens/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/services/capture_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalDbService().ensureInitialized();
  runApp(const FigureSkatingJumpApp());
}

class FigureSkatingJumpApp extends StatelessWidget {
  const FigureSkatingJumpApp({super.key});

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
        '/Login': (context) => const LoginView(),
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
  // REMOVE ONCE LIST OF ATHLETE IS DONE. FROM HERE
  late SkatingUser _skater;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  _asyncMethod() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot<Map<String, dynamic>> userInfoSnapshot = await firestore
        .collection("users")
        .doc("QbTascjmGwNo28lZPYWCQagIthI3")
        .get();
    SkatingUser s = SkatingUser.fromFirestore(
        firebaseAuth.currentUser?.uid, userInfoSnapshot);
    _skater = s;
  }
  // TO HERE

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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AcquisitionsView(skater: _skater)),
                );
              },
              child: const Text('Acquisitions')),
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
