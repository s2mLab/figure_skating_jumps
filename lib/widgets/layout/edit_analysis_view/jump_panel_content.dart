import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/jump_scores.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/jump_type.dart';
import 'package:figure_skating_jumps/models/jump.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/utils/skate_move_radio.dart';
import 'package:flutter/material.dart';

class JumpPanelContent extends StatefulWidget {
  final Jump _j;
  final void Function(Jump j, JumpType initialJumpType, int initialTime)
      _onModified;
  final void Function(Jump j, JumpType initialJumpType) _onDeleted;
  const JumpPanelContent(
      {super.key,
      required jump,
      required void Function(Jump j, JumpType initialJumpType, int initialTime)
          onModified,
      required void Function(Jump j, JumpType initial) onDeleted})
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
      padding: EdgeInsets.only(
          left: ReactiveLayoutHelper.getWidthFromFactor(8),
          right: ReactiveLayoutHelper.getWidthFromFactor(8),
          bottom: ReactiveLayoutHelper.getHeightFromFactor(12),
          top: ReactiveLayoutHelper.getHeightFromFactor(2)),
      child: Container(
          height: ReactiveLayoutHelper.getHeightFromFactor(300),
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
                              widget._onModified(
                                  _j!, _initialJumpType, _initialTime);
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
                          text: deleteAJumpButton,
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
                          text: editTemporalValuesButton,
                          onPressed: () {
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return _temporalValuesDialog();
                              },
                            );
                          },
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
      padding: EdgeInsets.symmetric(
          horizontal: ReactiveLayoutHelper.getWidthFromFactor(16)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                  "$rotationDegreesField${_j!.rotationDegrees.toStringAsFixed(3)}",
                  style: TextStyle(
                      fontSize: ReactiveLayoutHelper.getHeightFromFactor(
                          _labelFontSizeInPanel))),
              Row(
                children: [
                  Text(
                    scoreField,
                    style: TextStyle(
                        fontSize: ReactiveLayoutHelper.getHeightFromFactor(
                            _labelFontSizeInPanel)),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: ReactiveLayoutHelper.getWidthFromFactor(8)),
                    child: DropdownButton<int>(
                        selectedItemBuilder: (context) {
                          return jumpScores.map<Widget>((int item) {
                            // This is the widget that will be shown when you select an item.
                            // Here custom text style, alignment and layout size can be applied
                            // to selected item string.
                            return Container(
                              constraints: BoxConstraints(
                                  minWidth:
                                      ReactiveLayoutHelper.getWidthFromFactor(
                                          50)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    item.toString(),
                                    style: TextStyle(
                                        fontSize: ReactiveLayoutHelper
                                            .getHeightFromFactor(16),
                                        color: darkText,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }).toList();
                        },
                        value: _selectedScore,
                        menuMaxHeight:
                            ReactiveLayoutHelper.getWidthFromFactor(300),
                        items: List.generate(jumpScores.length, (index) {
                          return DropdownMenuItem<int>(
                            value: jumpScores[index],
                            child: Text(jumpScores[index].toString(),
                                style: TextStyle(
                                    fontSize: ReactiveLayoutHelper
                                        .getHeightFromFactor(16))),
                          );
                        }),
                        onChanged: (val) {
                          setState(() {
                            _selectedScore = val!;
                            _j!.score = _selectedScore;
                            widget._onModified(
                                _j!, _initialJumpType, _initialTime);
                            _initialJumpType = _selectedType;
                          });
                        }),
                  ),
                  IconButton(
                      iconSize: ReactiveLayoutHelper.getHeightFromFactor(24),
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
                            widget._onModified(
                                _j!, _initialJumpType, _initialTime);
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
                turnsField,
                style: TextStyle(
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(
                        _labelFontSizeInPanel)),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: ReactiveLayoutHelper.getWidthFromFactor(8)),
                child: SizedBox(
                    width: ReactiveLayoutHelper.getWidthFromFactor(120),
                    child: TextFormField(
                      style: TextStyle(
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(16)),
                      autovalidateMode: AutovalidateMode.always,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        return FieldValidators.doubleValidator(val);
                      },
                      onEditingComplete: () {
                        _j!.turns = double.parse(_rotationController.text);
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
      title: Text(
        deleteJumpDialogTitle,
        style:
            TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(24)),
      ),
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: ReactiveLayoutHelper.getWidthFromFactor(16),
                  bottom: ReactiveLayoutHelper.getHeightFromFactor(24),
                  top: ReactiveLayoutHelper.getHeightFromFactor(8)),
              child: const InstructionPrompt(confirmDeleteInfo, errorColor),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IceButton(
                    text: cancelLabel,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    textColor: paleText,
                    color: primaryColor,
                    iceButtonImportance: IceButtonImportance.mainAction,
                    iceButtonSize: IceButtonSize.small),
                IceButton(
                    text: continueToLabel,
                    onPressed: () {
                      widget._onDeleted(_j!, _initialJumpType);
                      Navigator.pop(context);
                    },
                    textColor: errorColor,
                    color: errorColorDark,
                    iceButtonImportance: IceButtonImportance.secondaryAction,
                    iceButtonSize: IceButtonSize.small),
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
        insetPadding: EdgeInsets.symmetric(
            horizontal: ReactiveLayoutHelper.getWidthFromFactor(8, true)),
        title: Text(commentDialogTitle,
            style: TextStyle(
                fontSize: ReactiveLayoutHelper.getHeightFromFactor(24))),
        children: [
          Form(
            key: _commentFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ReactiveLayoutHelper.getWidthFromFactor(16),
                      right: ReactiveLayoutHelper.getWidthFromFactor(16),
                      bottom: ReactiveLayoutHelper.getHeightFromFactor(24),
                      top: ReactiveLayoutHelper.getHeightFromFactor(8)),
                  child:
                      const InstructionPrompt(howToCommentInfo, secondaryColor),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ReactiveLayoutHelper.getWidthFromFactor(24)),
                  child: TextFormField(
                    style: TextStyle(
                        fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
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
                  padding: EdgeInsets.symmetric(
                      vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                  child: Text(chooseBelowCommentsLabel,
                      style: TextStyle(
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(16))),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ReactiveLayoutHelper.getWidthFromFactor(32)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IceButton(
                              text: fallComment,
                              onPressed: () {
                                _commentController.text = fallComment;
                              },
                              textColor: primaryColor,
                              color: primaryColor,
                              iceButtonImportance:
                                  IceButtonImportance.discreetAction,
                              iceButtonSize: IceButtonSize.medium),
                          IceButton(
                              text: notEnoughRotationComment,
                              onPressed: () {
                                _commentController.text =
                                    notEnoughRotationComment;
                              },
                              textColor: primaryColor,
                              color: primaryColor,
                              iceButtonImportance:
                                  IceButtonImportance.discreetAction,
                              iceButtonSize: IceButtonSize.medium)
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                                ReactiveLayoutHelper.getHeightFromFactor(8.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IceButton(
                                text: goodJobComment,
                                onPressed: () {
                                  _commentController.text = goodJobComment;
                                },
                                textColor: primaryColor,
                                color: primaryColor,
                                iceButtonImportance:
                                    IceButtonImportance.discreetAction,
                                iceButtonSize: IceButtonSize.medium),
                            IceButton(
                                text: stepOutComment,
                                onPressed: () {
                                  _commentController.text = stepOutComment;
                                },
                                textColor: primaryColor,
                                color: primaryColor,
                                iceButtonImportance:
                                    IceButtonImportance.discreetAction,
                                iceButtonSize: IceButtonSize.medium)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IceButton(
                        text: cancelLabel,
                        onPressed: () {
                          _initializeCommentController();
                          Navigator.pop(context);
                        },
                        textColor: primaryColor,
                        color: primaryColor,
                        iceButtonImportance:
                            IceButtonImportance.secondaryAction,
                        iceButtonSize: IceButtonSize.small),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              ReactiveLayoutHelper.getWidthFromFactor(16)),
                      child: IceButton(
                          text: saveLabel,
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
        insetPadding: EdgeInsets.symmetric(
            horizontal: ReactiveLayoutHelper.getWidthFromFactor(8, true)),
        title: Text(metricsDialogTitle,
            style: TextStyle(
                fontSize: ReactiveLayoutHelper.getHeightFromFactor(24))),
        children: [
          Form(
            key: _metricsFormKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: ReactiveLayoutHelper.getWidthFromFactor(24)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                ReactiveLayoutHelper.getHeightFromFactor(24)),
                        child: const InstructionPrompt(
                            advancedMetricsPromptInfo, secondaryColor),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                ReactiveLayoutHelper.getHeightFromFactor(24)),
                        child: const InstructionPrompt(
                            irreversibleDataModificationInfo, errorColor),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("$durationField (sec)",
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          _labelFontSizeInPanel))),
                          SizedBox(
                            width: ReactiveLayoutHelper.getWidthFromFactor(100),
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          16)),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                          Text("$startTimeField (sec)",
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          _labelFontSizeInPanel))),
                          SizedBox(
                            width: ReactiveLayoutHelper.getWidthFromFactor(100),
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          16)),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          _labelFontSizeInPanel))),
                          SizedBox(
                            width: ReactiveLayoutHelper.getWidthFromFactor(100),
                            child: TextFormField(
                              style: TextStyle(
                                  color: discreetText,
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          16)),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                          Text("$maxSpeedLabel (deg/sec)",
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          _labelFontSizeInPanel))),
                          SizedBox(
                            width: ReactiveLayoutHelper.getWidthFromFactor(100),
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: TextStyle(
                                  color: discreetText,
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          16)),
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
                Padding(
                  padding: EdgeInsets.only(
                      top: ReactiveLayoutHelper.getHeightFromFactor(8.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IceButton(
                          text: cancelLabel,
                          onPressed: () {
                            _initializeAdvancedMetricsControllers();
                            Navigator.pop(context);
                          },
                          textColor: primaryColor,
                          color: primaryColor,
                          iceButtonImportance:
                              IceButtonImportance.secondaryAction,
                          iceButtonSize: IceButtonSize.small),
                      IceButton(
                          text: saveLabel,
                          onPressed: () {
                            if (_metricsFormKey.currentState!.validate()) {
                              _metricsFormKey.currentState?.save();
                              widget._onModified(
                                  _j!, _initialJumpType, _initialTime);
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
                ),
              ],
            ),
          ),
        ]);
  }
}
