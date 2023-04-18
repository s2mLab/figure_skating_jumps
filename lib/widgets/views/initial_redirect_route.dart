import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/models/user_role.dart';
import 'package:figure_skating_jumps/services/local_db/active_session_manager.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/views/athlete_view.dart';
import 'package:figure_skating_jumps/widgets/views/list_athletes_view.dart';
import 'package:figure_skating_jumps/widgets/views/login_view.dart';
import 'package:figure_skating_jumps/widgets/views/missing_permissions_view.dart';
import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';

/// This widget is used as a gate before accessing the application.
/// It redirects you to the appropriate view depending of the state
/// of previous sign ins or according to errors that might have occured.
class InitialRedirectRoute extends StatelessWidget {
  late final bool _hasStoragePermissions;
  late final bool _hasNetwork;
  final List<ProcessorArchitecture> _unsupportedArchitectures = [
    ProcessorArchitecture.mips
  ];
  final List<ProcessorArchitecture> _untrustedArchitectures = [
    ProcessorArchitecture.arm,
    ProcessorArchitecture.x86,
    ProcessorArchitecture.unknown
  ];

  InitialRedirectRoute(
      {required bool hasStoragePermissions, required bool hasNetwork, Key? key})
      : _hasNetwork = hasNetwork,
        _hasStoragePermissions = hasStoragePermissions,
        super(key: key);

  /// Returns the appropriate [PageRoute] for redirection based on the user's current session and role.
  ///
  /// Returns:
  /// - If the user is not logged in, returns a [PageRoute] that leads to the [LoginView].
  /// - If the user is logged in and has a 'coach' role, returns a [PageRoute] that leads to the [ListAthletesView].
  /// - If the user is logged in and does not have a 'coach' role, returns a [PageRoute] that leads to the [CapturesView].
  Route _getRedirectRoute() {
    if (ActiveSessionManager().activeSession == null) {
      return PageRouteBuilder(
          settings: const RouteSettings(name: '/Login'),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginView());
    }

    return UserClient().currentSkatingUser!.role == UserRole.coach
        ? PageRouteBuilder(
            settings:
                const RouteSettings(name: '/ListAthletes', arguments: false),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const ListAthletesView())
        : PageRouteBuilder(
            settings: RouteSettings(
                name: '/Captures', arguments: UserClient().currentSkatingUser),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const CapturesView());
  }

  @override
  Widget build(BuildContext context) {
    ReactiveLayoutHelper.updateDimensions(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Route route = _getRedirectRoute();

      // Architectures that crash
      if (_unsupportedArchitectures.contains(SysInfo.kernelArchitecture)) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MissingPermissionsView(
                    message: architectureNotPermittedInfo)));
        return;
      }
      // Missing permissions to keep going
      if (!_hasStoragePermissions) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MissingPermissionsView(
                    message: pleaseActivatePermissionsInfo)));
        return;
      }
      // Missing permissions to keep going
      if (!_hasNetwork) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MissingPermissionsView(
                    message: pleaseActivateNetworkInfo)));
        return;
      }
      // Architectures that might crash
      if (_untrustedArchitectures.contains(SysInfo.kernelArchitecture)) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MissingPermissionsView(
                    message: architectureUntrusted, routeToOnBypass: route)));
        return;
      }

      Navigator.pushReplacement(context, route);
    });
    return const CircularProgressIndicator();
  }
}
