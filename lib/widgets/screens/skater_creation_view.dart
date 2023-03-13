import 'package:figure_skating_jumps/constants/sizes.dart';

import 'package:figure_skating_jumps/utils/field_validators.dart';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../buttons/ice_button.dart';
import '../layout/ice_drawer_menu.dart';
import '../layout/topbar.dart';
import '../prompts/instruction_prompt.dart';
import '../titles/page_title.dart';

class SkaterCreationView extends StatefulWidget {
  const SkaterCreationView({super.key});

  @override
  State<SkaterCreationView> createState() => _SkaterCreationViewState();
}

class _SkaterCreationViewState extends State<SkaterCreationView> {
  String _skaterName = '';
  String _skaterSurname = '';
  String _skaterEmail = '';
  final _newSkaterKey = GlobalKey<FormState>();
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _nameController;

  @override
  void initState() {
    _surnameController = TextEditingController(text: _skaterSurname);
    _nameController = TextEditingController(text: _skaterName);
    _emailController = TextEditingController(text: _skaterEmail);
    super.initState();
  }

  @override
  void dispose() {
    _surnameController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const Topbar(isUserDebuggingFeature: false),
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        drawerScrimColor: Colors.transparent,
        drawerEnableOpenDragGesture: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - topbarHeight,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: primaryBackground,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  // TODO: might want to save the boxshadow value in a style file for future use
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 24.0, top: 8.0),
                      child: PageTitle(text: "Ajout d'un patineur"),
                    ),
                    const InstructionPrompt(
                        createAthleteExplainPrompt, secondaryColor),
                    Expanded(
                      child: Column(children: [
                        Form(
                          key: _newSkaterKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.name,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _surnameController,
                                onChanged: (value) {
                                  setState(() {
                                    _skaterSurname = value;
                                  });
                                },
                                validator: (value) {
                                  return FieldValidators.newNameValidator(
                                      value);
                                },
                                decoration: const InputDecoration(
                                  labelText: surname,
                                  labelStyle: TextStyle(
                                      fontSize: 16, color: discreetText),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _nameController,
                                onChanged: (value) {
                                  setState(() {
                                    _skaterName = value;
                                  });
                                },
                                validator: (value) {
                                  return FieldValidators.newNameValidator(
                                      value);
                                },
                                decoration: const InputDecoration(
                                  labelText: name,
                                  labelStyle: TextStyle(
                                      fontSize: 16, color: discreetText),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _emailController,
                                onChanged: (value) {
                                  setState(() {
                                    _skaterEmail = value;
                                  });
                                },
                                validator: (value) {
                                  return FieldValidators.newEmailValidator(
                                      value);
                                },
                                decoration: const InputDecoration(
                                  labelText: email,
                                  labelStyle: TextStyle(
                                      fontSize: 16, color: discreetText),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IceButton(
                                    text: createAccount,
                                    onPressed: () async {
                                      if (_newSkaterKey.currentState != null &&
                                          _newSkaterKey.currentState!
                                              .validate()) {
                                        // TODO : await _onSkaterAccountCreate();
                                      }
                                    },
                                    textColor: paleText,
                                    color: primaryColor,
                                    iceButtonImportance:
                                        IceButtonImportance.mainAction,
                                    iceButtonSize: IceButtonSize.medium),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
/* TODO: Waiting on firebase account creation for skaters (no passwords yet when coach creates the account)
  Future<bool> _onSkaterAccountCreate() async {
    await UserClient().signUp(email: _skaterEmail, password: password, userInfo: UserInfo());
    _resetForm();
  }

  void _resetForm() {
    _skaterName = '';
    _skaterSurname = '';
    _skaterEmail = '';
  }
  */
}
