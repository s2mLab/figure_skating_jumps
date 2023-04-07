import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/services/manager/active_session_manager.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:flutter/material.dart';

class InitialRedirectRoute extends StatelessWidget {
  final bool _canFunction;

  const InitialRedirectRoute(bool canFunction, {Key? key}) : _canFunction = canFunction, super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_canFunction) {
      // debugPrint(ActiveSessionManager().activeSession.toString());
      if (ActiveSessionManager().activeSession != null) {
        UserClient().currentSkatingUser!.role == UserRole.coach
            ? Navigator.pushReplacementNamed(context, '/ListAthletes', arguments: false)
            : Navigator.pushReplacementNamed(context, '/Acquisitions', arguments: UserClient().currentSkatingUser);
      }
      Navigator.pushReplacementNamed(context, '/Login');
    }
    debugPrint("HEY THERE");
    Navigator.pushReplacementNamed(context, '/MissingPermissions');

    return const CircularProgressIndicator();
  }
}