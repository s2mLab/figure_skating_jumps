import 'package:figure_skating_jumps/widgets/buttons/x_sens_dot_list_element.dart';
import 'package:flutter/material.dart';

import '../../../models/jump.dart';

class JumpPanelHeader extends StatefulWidget {
  final Jump _jump;
  const JumpPanelHeader({super.key, required jump}) : _jump = jump;

  @override
  State<StatefulWidget> createState() => _JumpPanelHeaderState();

}

class _JumpPanelHeaderState extends State<JumpPanelHeader> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: XSensDotListElement(text: "jump", graphic: Container(), hasLine: true, lineColor: widget._jump.type.color,),
    );
  }

}