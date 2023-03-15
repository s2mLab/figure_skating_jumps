import 'package:figure_skating_jumps/enums/x_sens_device_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class XSensStateIcon extends StatelessWidget {
  static const double _smallHeight = 64;
  static const double _bigHeight = 160;
  final bool _isSmall;
  final XSensDeviceState _state;

  const XSensStateIcon(this._isSmall, this._state, {super.key});

  @override
  Widget build(BuildContext context) {
    String size = '';
    if (_isSmall) {
      size = 'small-';
    }
    switch (_state) {
      case XSensDeviceState.reconnecting:
        return SvgPicture.asset('assets/vectors/${size}XSens-Ico-Missing.svg',
            height: _isSmall ? _smallHeight : _bigHeight);
      case XSensDeviceState.connected:
        return SvgPicture.asset('assets/vectors/${size}XSens-Ico-Co.svg',
            height: _isSmall ? _smallHeight : _bigHeight);
      case XSensDeviceState.disconnected:
        return SvgPicture.asset('assets/vectors/${size}XSens-Ico-Deco.svg',
            height: _isSmall ? _smallHeight : _bigHeight);
    }
  }
}
