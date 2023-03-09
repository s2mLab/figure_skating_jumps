import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/prompts/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../../enums/user_role.dart';
import '../../models/skating_user.dart';
import '../../services/user_client.dart';
import '../layout/progression_dots_row.dart';

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
                  const EdgeInsets.symmetric(vertical: 48.0, horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 100,
                      child: SvgPicture.asset(
                          'assets/vectors/blanc-logo-patinage-quebec.svg')),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 48.0),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryBackground,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        boxShadow: [
                          // TODO: might want to save the boxshadow value in a style file for future use
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 12,
                                      child: ProgressionDotsRow(
                                          steps: 2, state: 1)),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: PageTitle(text: coachCreateAccountTitle),
                            ),
                            const InstructionPrompt(
                                ifNotAnAthletePrompt, secondaryColor),
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
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _surnameController,
              onChanged: (value) {
                setState(() {
                  _coachSurname = value;
                });
              },
              validator: (value) {
                return _nameValidator(value);
              },
              decoration: const InputDecoration(
                labelText: surname,
                labelStyle: TextStyle(fontSize: 16, color: discreetText),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  _coachName = value;
                });
              },
              validator: (value) {
                return _nameValidator(value);
              },
              decoration: const InputDecoration(
                labelText: name,
                labelStyle: TextStyle(fontSize: 16, color: discreetText),
              ),
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _emailController,
              onChanged: (value) {
                setState(() {
                  _coachEmail = value;
                });
              },
              validator: (value) {
                return _emailValidator(value);
              },
              decoration: const InputDecoration(
                labelText: email,
                labelStyle: TextStyle(fontSize: 16, color: discreetText),
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
                text: continueTo,
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
                  text: alreadyHaveAccount,
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _passwordController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _coachPassword = value;
                });
              },
              validator: (value) {
                return _passValidator(value);
              },
              decoration: const InputDecoration(
                labelText: password,
                labelStyle: TextStyle(fontSize: 16, color: discreetText),
              ),
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: _confirmPassController,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  _coachPassConfirm = value;
                });
              },
              validator: (value) {
                return _passConfirmValidator(value, _coachPassword);
              },
              decoration: const InputDecoration(
                labelText: passConfirmSame,
                labelStyle: TextStyle(fontSize: 16, color: discreetText),
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
                text: confirmCreateCoachAccount,
                onPressed: () async {
                  await onAccountCreatePressed();
                },
                textColor: paleText,
                color: primaryColor,
                iceButtonImportance: IceButtonImportance.mainAction,
                iceButtonSize: IceButtonSize.medium),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: IceButton(
                  text: goBack,
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

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    if (value.length > 255) {
      return reduceCharacter;
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]+$').hasMatch(value)) {
      return invalidEmailFormat;
    }
    return null;
  }

  String? _passValidator(String? value) {
    if (value == null || value.isEmpty) {
      return pleaseFillField;
    }
    if (value.length < 10) {
      return addCharacters;
    }
    return null;
  }

  String? _passConfirmValidator(String? value, String? password) {
    return value == password ? null : passwordMismatch;
  }

  Future<bool> _createAccount() async {
    try {
      await UserClient().signUp(email: _coachEmail, password: _coachPassword,
          userInfo: SkatingUser(_coachSurname, _coachName, UserRole.coach));
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
                    title: const Text(accountCreationError),
                    titleTextStyle: const TextStyle(
                        fontSize: 20, color: errorColor, fontFamily: 'Jost'),
                    content: Text('$_errorStateMessage\n$tryLater'));
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
