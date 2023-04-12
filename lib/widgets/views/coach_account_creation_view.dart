import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../constants/styles.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../../enums/user_role.dart';
import '../../models/skating_user.dart';
import '../../services/user_client.dart';
import '../utils/progression_dots_row.dart';

class CoachAccountCreationView extends StatefulWidget {
  const CoachAccountCreationView({super.key});

  @override
  State<CoachAccountCreationView> createState() =>
      _CoachAccountCreationViewState();
}

class _CoachAccountCreationViewState extends State<CoachAccountCreationView> {
  String _coachName = '';
  String _coachSurname = '';
  String _coachPassword = '';
  String _coachPassConfirm = '';
  String _coachEmail = '';
  String _errorStateMessage = '';
  int _pageIndex = 0;
  final _personalInfoKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPassController;

  @override
  void initState() {
    _surnameController = TextEditingController(text: _coachSurname);
    _nameController = TextEditingController(text: _coachName);
    _emailController = TextEditingController(text: _coachEmail);
    _passwordController = TextEditingController(text: _coachPassword);
    _confirmPassController = TextEditingController(text: _coachPassConfirm);
    super.initState();
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColorLight,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(48), horizontal: ReactiveLayoutHelper.getWidthFromFactor(32)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: ReactiveLayoutHelper.getHeightFromFactor(100),
                      child: SvgPicture.asset(
                          'assets/vectors/blanc-logo-patinage-quebec.svg')),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(top: ReactiveLayoutHelper.getHeightFromFactor(48)),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [connectionShadow],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: ReactiveLayoutHelper.getHeightFromFactor(12),
                                      child: ProgressionDotsRow(
                                          steps: 2, state: 1)),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                              child: const PageTitle(text: coachCreateAccountTitle),
                            ),
                            const InstructionPrompt(
                                ifNotAnAthleteInfo, secondaryColor),
                            Expanded(
                              child: IndexedStack(
                                index: _pageIndex,
                                children: [_informationForm(), _passwordForm()],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _informationForm() {
    return Column(children: [
      Form(
        key: _personalInfoKey,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _surnameController,
              onChanged: (value) {
                setState(() {
                  _coachSurname = value;
                });
              },
              validator: (value) {
                return FieldValidators.newNameValidator(value);
              },
              decoration: InputDecoration(
                labelText: surnameField,
                labelStyle: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16), color: discreetText),

              ),
            ),
            TextFormField(
              style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _coachName = value;
                });
              },
              validator: (value) {
                return FieldValidators.newNameValidator(value);
              },
              decoration: InputDecoration(
                labelText: nameField,
                labelStyle: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16), color: discreetText),
              ),
            ),
            TextFormField(
              style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _emailController,
              onChanged: (value) {
                setState(() {
                  _coachEmail = value;
                });
              },
              validator: (value) {
                return FieldValidators.newEmailValidator(value);
              },
              decoration: InputDecoration(
                labelText: emailField,
                labelStyle: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16), color: discreetText),

              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IceButton(
                text: continueToLabel,
                onPressed: () {
                  if (_personalInfoKey.currentState != null &&
                      _personalInfoKey.currentState!.validate()) {
                    setState(() {
                      _toPassword();
                    });
                  }
                },
                textColor: paleText,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.mainAction,
                iceButtonSize: IceButtonSize.medium),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: IceButton(
                  text: alreadyHaveAccountButton,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context,
                      '/Login',
                    );
                  },
                  textColor: primaryColor,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.secondaryAction,
                  iceButtonSize: IceButtonSize.medium),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _passwordForm() {
    return Column(children: [
      Form(
        key: _passwordKey,
        child: Column(
          children: [
            TextFormField(
              style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _passwordController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _coachPassword = value;
                });
              },
              validator: (value) {
                return FieldValidators.newPassValidator(value);
              },
              decoration: InputDecoration(
                labelText: passwordField,
                labelStyle: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16), color: discreetText),
              ),
            ),
            TextFormField(
              style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _confirmPassController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _coachPassConfirm = value;
                });
              },
              validator: (value) {
                return FieldValidators.newPassConfirmValidator(
                    value, _coachPassword);
              },
              decoration: InputDecoration(
                labelText: passConfirmSameLabel,
                labelStyle: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16), color: discreetText),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IceButton(
                text: confirmCreateCoachAccountButton,
                onPressed: () async {
                  await onAccountCreatePressed();
                },
                textColor: paleText,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.mainAction,
                iceButtonSize: IceButtonSize.medium),
            Padding(
              padding: EdgeInsets.only(top: ReactiveLayoutHelper.getHeightFromFactor(8)),
              child: IceButton(
                  text: goBackLabel,
                  onPressed: () {
                    setState(() {
                      _toAccount();
                    });
                  },
                  textColor: primaryColor,
                  color: primaryColor,
                  iceButtonImportance: IceButtonImportance.secondaryAction,
                  iceButtonSize: IceButtonSize.medium),
            )
          ],
        ),
      ),
    ]);
  }

  Future<bool> _createAccount() async {
    try {
      await UserClient().signUp(
          email: _coachEmail,
          password: _coachPassword,
          userInfo: SkatingUser(
              _coachSurname, _coachName, UserRole.coach, _coachEmail));
      return Future.value(true);
    } on Exception catch (e) {
      _errorStateMessage = e.toString();
      return Future.value(false);
    }
  }

  void _toPassword() {
    setState(() {
      _pageIndex = 1;
    });
  }

  Future<void> onAccountCreatePressed() async {
    if (_passwordKey.currentState != null &&
        _passwordKey.currentState!.validate()) {
      if (await _createAccount()) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/ManageDevices');
        }
      } else {
        if (mounted) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                    title: const Text(accountCreationErrorLabel),
                    titleTextStyle: TextStyle(
                        fontSize: ReactiveLayoutHelper.getHeightFromFactor(20), color: errorColor, fontFamily: 'Jost'),
                    content: Text('$_errorStateMessage\n$tryLaterLabel'));
              });
        }
      }
    }
  }

  void _toAccount() {
    setState(() {
      _pageIndex = 0;
      _coachPassword = '';
      _coachPassConfirm = '';
      _confirmPassController.text = '';
      _passwordController.text = '';
    });
  }
}
