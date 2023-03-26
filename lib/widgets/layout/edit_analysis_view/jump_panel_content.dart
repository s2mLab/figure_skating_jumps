import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/utils/skate_move_radio.dart';
import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/jump_scores.dart';
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
  late int _selectedScore;
  late TextEditingController _commentController;
  //late Controller _durationController;
  late TextEditingController _rotationController;
  final _commentFormKey = GlobalKey<FormState>();
  final _metricsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _j = widget._j;
    _selectedScore = _j!.score;
    _selectedType = _j!.type;
    _commentController = TextEditingController(text: _j!.comment);
    _rotationController =
        TextEditingController(text: _j!.rotationDegrees.toString());
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0, top: 2.0),
      child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            boxShadow: [connectionShadow],
            color: primaryBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        List.generate(JumpType.values.length - 1, (index) {
                      return SkateMoveRadio(
                          value: JumpType.values[index],
                          groupValue: _selectedType,
                          onChanged: (JumpType newValue) {
                            setState(() {
                              _selectedType = newValue;
                              _j!.type = _selectedType;
                              widget._onModified(_j!);
                            });
                          });
                    }),
                  ),
                  _jumpModificationForm(),
                  Center(
                    child: IceButton(
                        text: deleteAJump,
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return _confirmDeleteJumpDialog();
                              });
                        },
                        textColor: errorColor,
                        color: errorColorDark,
                        iceButtonImportance:
                            IceButtonImportance.secondaryAction,
                        iceButtonSize: IceButtonSize.small),
                  )
                ],
              )),
            ],
          )),
    );
  }

  Widget _confirmDeleteJumpDialog() {
    return SimpleDialog(
      title: const Text(deleteJumpDialogTitle),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24.0, bottom: 24.0),
              child: InstructionPrompt(confirmDelete, errorColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IceButton(
                    text: cancel,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: paleText,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.mainAction,
                    iceButtonSize: IceButtonSize.small),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: IceButton(
                      text: continueTo,
                      onPressed: () {
                        //TODO: delete jump
                      },
                      textColor: errorColor,
                      color: errorColorDark,
                      iceButtonImportance: IceButtonImportance.secondaryAction,
                      iceButtonSize: IceButtonSize.small),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _jumpModificationForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Form(
          key: _metricsFormKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Score",
                    style: TextStyle(fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButton<int>(
                        selectedItemBuilder: (context) {
                          return jumpScores.map<Widget>((int item) {
                            // This is the widget that will be shown when you select an item.
                            // Here custom text style, alignment and layout size can be applied
                            // to selected item string.
                            return Container(
                              constraints: const BoxConstraints(minWidth: 50),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item.toString(),
                                    style: const TextStyle(
                                        color: darkText,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                        value: _selectedScore,
                        menuMaxHeight: 300,
                        items: List.generate(jumpScores.length, (index) {
                          return DropdownMenuItem<int>(
                            value: jumpScores[index],
                            child: Text(jumpScores[index].toString()),
                          );
                        }),
                        onChanged: (val) {
                          setState(() {
                            _selectedScore = val!;
                            _j!.score = _selectedScore;
                            widget._onModified(_j!);
                            //TODO: toast
                          });
                        }),
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return _commentDialog();
                            }).then((value) {
                          if (value == null) return;
                          setState(() {
                            _commentController.text = value;
                            _j!.comment = value;
                            widget._onModified(_j!);
                          });
                        });
                      },
                      icon: const Icon(Icons.comment, color: primaryColorLight))
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Degrés de rotation",
                        style: TextStyle(fontSize: 16),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 120,
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              keyboardType: TextInputType.number,
                          validator: (val) {
                                return FieldValidators.doubleValidator(val);
                          },
                              onEditingComplete: () {
                                _j!.rotationDegrees = _rotationController.text;
                                widget._onModified(_j!);
                              },
                          controller: _rotationController,
                        )),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Widget _commentDialog() {
    return SimpleDialog(title: const Text(commentDialogTitle), children: [
      Form(
        key: _commentFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 24.0, bottom: 24.0),
              child: InstructionPrompt(howToComment, secondaryColor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TextFormField(
                controller: _commentController,
                minLines: 2,
                maxLines: 5,
                onSaved: (val) {
                  Navigator.pop(context, val);
                },
                validator: (val) =>
                    null, //There is no form of comment that should be filtered out
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IceButton(
                    text: cancel,
                    onPressed: () {
                      _commentController.text =
                          _j!.comment; // todo: refactor when setter in jump
                      Navigator.pop(context);
                    },
                    textColor: primaryColor,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.secondaryAction,
                    iceButtonSize: IceButtonSize.small),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: IceButton(
                      text: save,
                      onPressed: () {
                        _commentFormKey.currentState?.save();
                      },
                      textColor: paleText,
                      color: primaryColor,
                      iceButtonImportance: IceButtonImportance.mainAction,
                      iceButtonSize: IceButtonSize.small),
                ),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
