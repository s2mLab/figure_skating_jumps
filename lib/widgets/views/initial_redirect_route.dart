import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/services/manager/active_session_manager.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:flutter/material.dart';

class InitialRedirectRoute extends StatelessWidget {
  late final bool _canFunction;

  InitialRedirectRoute(bool canFunction, {Key? key}) : super(key: key) {
    _canFunction = canFunction;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_canFunction) {
        Navigator.pushReplacementNamed(context, '/MissingPermissions');
        return;
      }
      if (ActiveSessionManager().activeSession == null) {
        Navigator.pushReplacementNamed(context, '/Login');
        return;
      }
      UserClient().currentSkatingUser!.role == UserRole.coach
          ? Navigator.pushReplacementNamed(context, '/ListAthletes',
              arguments: false)
          : Navigator.pushReplacementNamed(context, '/Acquisitions',
              arguments: UserClient().currentSkatingUser);
    });
    return const CircularProgressIndicator();
  }
}
