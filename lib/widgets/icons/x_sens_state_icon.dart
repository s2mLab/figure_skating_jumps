import 'package:figure_skating_jumps/enums/x_sens_connection_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class XSensStateIcon extends StatelessWidget {
  static const double _smallHeight = 64;
  static const double _bigHeight = 160;
  final bool _isSmall;
  final XSensConnectionState _state;

  const XSensStateIcon(this._isSmall, this._state, {super.key});

  @override
  Widget build(BuildContext context) {
    String size = '';
    if (_isSmall) {
      size = 'small-';
    }
    switch (_state) {
      case XSensConnectionState.reconnecting:
        return SvgPicture.asset('assets/vectors/${size}XSens-Ico-Missing.svg',
            height: _isSmall ? _smallHeight : _bigHeight);
      case XSensConnectionState.connected:
        return SvgPicture.asset('assets/vectors/${size}XSens-Ico-Co.svg',
            height: _isSmall ? _smallHeight : _bigHeight);
      case XSensConnectionState.disconnected:
        return SvgPicture.asset('assets/vectors/${size}XSens-Ico-Deco.svg',
            height: _isSmall ? _smallHeight : _bigHeight);
    }
  }
}
