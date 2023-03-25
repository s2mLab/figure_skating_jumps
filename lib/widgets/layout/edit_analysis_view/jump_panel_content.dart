import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/widgets/utils/skate_move_radio.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';
import '../../../enums/ice_button_importance.dart';
import '../../../enums/ice_button_size.dart';
import '../../../models/jump.dart';
import '../../buttons/ice_button.dart';

class JumpPanelContent extends StatefulWidget {
  final Jump _j;
  final void Function(Jump j) _onModified;
  const JumpPanelContent(
      {super.key, required jump, required void Function(Jump j) onModified})
      : _j = jump,
        _onModified = onModified;

  @override
  State<JumpPanelContent> createState() => _JumpPanelContentState();
}

class _JumpPanelContentState extends State<JumpPanelContent> {
  Jump? _j;
  late JumpType _selectedType;

  @override
  void initState() {
    _j = widget._j;
    _selectedType = _j!.type;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: _j!.type.color, style: BorderStyle.solid, width: 1)),
        child: Column(
          children: [
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(JumpType.values.length - 1, (index) {
                    return SkateMoveRadio(
                        value: JumpType.values[index],
                        groupValue: _selectedType,
                        onChanged: (JumpType newValue) {
                          setState(() {
                            _selectedType = newValue;
                            _j?.type = newValue;
                            widget._onModified(_j!);
                          });
                        });
                  }),
                ),
                Row(),
                Center(
                  child: IceButton(
                      text: deleteAJump,
                      onPressed: () {},
                      textColor: errorColor,
                      color: errorColorDark,
                      iceButtonImportance: IceButtonImportance.secondaryAction,
                      iceButtonSize: IceButtonSize.small),
                )
              ],
            )),
          ],
        ));
  }
}
