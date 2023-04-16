import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/user_role.dart';
import 'package:figure_skating_jumps/services/manager/active_session_manager.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/views/missing_permissions_view.dart';
import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';



class InitialRedirectRoute extends StatelessWidget {
  late final bool _canFunction;
  final List<ProcessorArchitecture> _unsupportedArchitectures = [ProcessorArchitecture.arm64, ProcessorArchitecture.mips];

  InitialRedirectRoute(bool canFunction, {Key? key}) : super(key: key) {
    _canFunction = canFunction;
  }

  @override
  Widget build(BuildContext context) {
    ReactiveLayoutHelper.updateDimensions(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_unsupportedArchitectures.contains(SysInfo.kernelArchitecture)) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MissingPermissionsView(message: architectureNotPermittedInfo)));
        return;
      }
      if (!_canFunction) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MissingPermissionsView(message: pleaseActivatePermissionsInfo)));
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
