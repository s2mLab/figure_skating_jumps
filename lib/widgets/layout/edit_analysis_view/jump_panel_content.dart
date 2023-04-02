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
  final void Function(Jump j, JumpType initialJumpType, int initialTime) _onModified;
  final void Function(Jump j, JumpType initialJumpType) _onDeleted;
  const JumpPanelContent(
      {super.key, required jump, required void Function(Jump j, JumpType initialJumpType, int initialTime) onModified, required void Function(Jump j, JumpType initial) onDeleted})
      : _j = jump,
        _onModified = onModified,
        _onDeleted = onDeleted;

  @override
  State<JumpPanelContent> createState() => _JumpPanelContentState();
}

class _JumpPanelContentState extends State<JumpPanelContent> {
  final int _maxDigitsForDoubleData = 3;
  final double _labelFontSizeInPanel = 14;
  late JumpType _initialJumpType;
  late int _initialTime;
  Jump? _j;
  late JumpType _selectedType;
  late int _selectedScore;
  late TextEditingController _commentController;
  late TextEditingController _durationController;
  late TextEditingController _startTimeController;
  late TextEditingController _rotationController;
  late TextEditingController _timeToMaxSpeedController;
  late TextEditingController _maxSpeedController;
  final _commentFormKey = GlobalKey<FormState>();
  final _metricsFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _j = widget._j;
    _initialJumpType = _j!.type;
    _initialTime = _j!.time;
    _selectedScore = _j!.score;
    _selectedType = _j!.type;
    _initializeAllTextControllers();
    super.initState();
  }

  void _initializeAllTextControllers() {
    _initializeCommentController();
    _rotationController = TextEditingController(
        text: _j!.turns.toStringAsFixed(_maxDigitsForDoubleData));
    _initializeAdvancedMetricsControllers();
  }

  void _initializeCommentController() {
    _commentController = TextEditingController(text: _j!.comment);
  }

  void _initializeAdvancedMetricsControllers() {
    _durationController = TextEditingController(text: _j!.duration.toString());
    _startTimeController = TextEditingController(text: _j!.time.toString());
    _timeToMaxSpeedController = TextEditingController(
        text: _j!.durationToMaxSpeed.toStringAsFixed(_maxDigitsForDoubleData));
    _maxSpeedController = TextEditingController(
        text: _j!.maxRotationSpeed.toStringAsFixed(_maxDigitsForDoubleData));
  }

  @override
  void dispose() {
    _commentController.dispose();
    _durationController.dispose();
    _startTimeController.dispose();
    _rotationController.dispose();
    _timeToMaxSpeedController.dispose();
    _maxSpeedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 12.0, top: 2.0),
      child: Container(
          height: 248,
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              widget._onModified(_j!, _initialJumpType, _initialTime);
                              _initialJumpType = _selectedType;
                            });
                          });
                    }),
                  ),
                  _jumpModificationForm(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IceButton(
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
                      IceButton(
                          text: editTemporalValues,
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return _temporalValuesDialog();
                              },
                            );
                          }, // TODO: video preview
                          textColor: primaryColor,
                          color: primaryColor,
                          iceButtonImportance:
                              IceButtonImportance.secondaryAction,
                          iceButtonSize: IceButtonSize.small)
                    ],
                  )
                ],
              )),
            ],
          )),
    );
  }

  Widget _jumpModificationForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("$rotationDegrees${_j!.rotationDegrees.toStringAsFixed(3)}",
                  style: TextStyle(fontSize: _labelFontSizeInPanel)),
              Row(
                children: [
                  Text(
                    score,
                    style: TextStyle(fontSize: _labelFontSizeInPanel),
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
                            widget._onModified(_j!, _initialJumpType, _initialTime);
                            _initialJumpType = _selectedType;
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
                            widget._onModified(_j!, _initialJumpType, _initialTime);
                            _initialJumpType = _selectedType;
                          });
                        });
                      },
                      icon: const Icon(Icons.comment, color: primaryColorLight))
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                turns,
                style: TextStyle(fontSize: _labelFontSizeInPanel),
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
                        _j!.turns =
                            double.parse(_rotationController.text);
                        widget._onModified(_j!, _initialJumpType, _initialTime);
                        _initialJumpType = _selectedType;
                      },
                      controller: _rotationController,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //This dialog is kept in this class because it references the jump and modifies its value through it
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
                        widget._onDeleted(_j!, _initialJumpType);
                        Navigator.pop(context);
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

  //This dialog is kept in this class because it references the context and returns a value through it
  Widget _commentDialog() {
    return SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        title: const Text(commentDialogTitle), children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Ou choisir parmi les commentaires suivants:"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IceButton(
                    text: cancel,
                    onPressed: () {
                      _initializeCommentController();
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

  //This dialog is kept in this class because it references the jump and modifies its value through it
  Widget _temporalValuesDialog() {
    return SimpleDialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        title: const Text(metricsDialogTitle), children: [
      Form(
        key: _metricsFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: InstructionPrompt(
                        advancedMetricsPrompt, secondaryColor),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: InstructionPrompt(
                        irreversibleDataModification, errorColor),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$durationLabel (sec)",
                          style: TextStyle(fontSize: _labelFontSizeInPanel)),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _durationController,
                          maxLines: 1,
                          onSaved: (val) {
                            _j!.duration = int.parse(val!);
                          },
                          validator: (val) =>
                              FieldValidators.nonNegativeValidator(val),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$startTimeLabel (sec)",
                          style: TextStyle(fontSize: _labelFontSizeInPanel)),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _startTimeController,
                          maxLines: 1,
                          onSaved: (val) {
                            _j!.time = int.parse(val!);
                          },
                          validator: (val) =>
                              FieldValidators.nonNegativeValidator(val),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$timeToMaxSpeedLabel (sec)",
                          style: TextStyle(fontSize: _labelFontSizeInPanel)),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(color: discreetText),
                          enabled: false,
                          controller: _timeToMaxSpeedController,
                          maxLines: 1,
                          validator: (val) =>
                              FieldValidators.doubleValidator(val),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("$maxSpeedLabel (sec)",
                          style: TextStyle(fontSize: _labelFontSizeInPanel)),
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(color: discreetText),
                          enabled: false,
                          controller: _maxSpeedController,
                          maxLines: 1,
                          validator: (val) =>
                              FieldValidators.doubleValidator(val),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IceButton(
                    text: cancel,
                    onPressed: () {
                      _initializeAdvancedMetricsControllers();
                      Navigator.pop(context);
                    },
                    textColor: primaryColor,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.secondaryAction,
                    iceButtonSize: IceButtonSize.small),
                IceButton(
                    text: save,
                    onPressed: () {
                      if (_metricsFormKey.currentState!.validate()) {
                        _metricsFormKey.currentState?.save();
                        widget._onModified(_j!, _initialJumpType, _initialTime);
                        _initialJumpType = _selectedType;
                        Navigator.pop(context);
                      }
                    },
                    textColor: paleText,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.mainAction,
                    iceButtonSize: IceButtonSize.small),
              ],
            ),
          ],
        ),
      ),
    ]);
  }
}
