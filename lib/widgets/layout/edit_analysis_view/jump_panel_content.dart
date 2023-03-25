import 'package:figure_skating_jumps/constants/styles.dart';
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
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0, top: 2.0),
      child: Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [connectionShadow],
              color: primaryBackground,
              borderRadius: BorderRadius.circular(8),),
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
                              //TODO: _j?.type = newValue;
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
          )),
    );
  }
}
