import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/services/manager/active_session_manager.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/views/athlete_view.dart';
import 'package:figure_skating_jumps/widgets/views/list_athletes_view.dart';
import 'package:figure_skating_jumps/widgets/views/login_view.dart';
import 'package:figure_skating_jumps/widgets/views/missing_permissions_view.dart';
import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';

class InitialRedirectRoute extends StatelessWidget {
  late final bool _canFunction;
  final List<ProcessorArchitecture> _unsupportedArchitectures = [
    ProcessorArchitecture.mips
  ];
  final List<ProcessorArchitecture> _untrustedArchitectures = [
    ProcessorArchitecture.arm,
    ProcessorArchitecture.x86,
    ProcessorArchitecture.unknown
  ];

  InitialRedirectRoute(bool canFunction, {Key? key}) : super(key: key) {
    _canFunction = canFunction;
  }

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
                name: '/Acquisitions',
                arguments: UserClient().currentSkatingUser),
            pageBuilder: (context, animation, secondaryAnimation) =>
                const AthleteView());
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
      // Architectures that might crash
      if (_untrustedArchitectures.contains(SysInfo.kernelArchitecture)) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MissingPermissionsView(
                    message: architectureUntrusted, routeToOnBypass: route)));
        return;
      }
      // Missing permissions to keep going
      if (!_canFunction) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MissingPermissionsView(
                    message: pleaseActivatePermissionsInfo)));
        return;
      }
      Navigator.pushReplacement(context, route);
    });
    return const CircularProgressIndicator();
  }
}
