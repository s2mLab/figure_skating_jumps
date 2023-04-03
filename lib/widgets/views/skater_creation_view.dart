import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/services/user_client.dart';

import 'package:figure_skating_jumps/utils/field_validators.dart';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../../enums/user_role.dart';
import '../buttons/ice_button.dart';
import '../layout/scaffold/ice_drawer_menu.dart';
import '../layout/scaffold/topbar.dart';
import '../prompts/instruction_prompt.dart';
import '../titles/page_title.dart';
import 'dart:developer' as developer;

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
              decoration: const BoxDecoration(
                color: primaryBackground,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 24.0, top: 8.0),
                      child: PageTitle(text: addASkaterTitle),
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
                                if (UserClient().currentSkatingUser!.role ==
                                    UserRole.iceSkater)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 16.0),
                                    child: InstructionPrompt(
                                        warnAccountTypeChange,
                                        primaryColorLight),
                                  ),
                                IceButton(
                                    text: createAccount,
                                    onPressed: () async {
                                      String coachId =
                                          UserClient().currentSkatingUser!.uID!;
                                      if (_newSkaterKey.currentState != null &&
                                          _newSkaterKey.currentState!
                                              .validate()) {
                                        // Ideally this would not use a try-catch as a condition-like structure
                                        try {
                                          await UserClient()
                                              .createAndLinkSkater(
                                                  skaterEmail: _skaterEmail,
                                                  coachId: coachId,
                                                  firstName: _skaterSurname,
                                                  lastName: _skaterName);
                                        } on ConflictException catch (e) {
                                          developer.log(e.devMessage);
                                          String? skatingUserUID =
                                              await UserClient()
                                                  .linkExistingSkater(
                                                      skaterEmail: _skaterEmail,
                                                      coachId: coachId);
                                          if (skatingUserUID != null) {
                                            UserClient()
                                                .currentSkatingUser!
                                                .traineesID
                                                .add(skatingUserUID);
                                          }
                                          if (mounted) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return Dialog(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            skatingUserUID ==
                                                                    null
                                                                ? athleteAlreadyInList
                                                                : athleteAlreadyExists,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        20),
                                                          ),
                                                        ),
                                                        IceButton(
                                                            text: confirmText,
                                                            onPressed: () {
                                                              Navigator
                                                                  .pushReplacementNamed(
                                                                      context,
                                                                      '/ListAthletes');
                                                            },
                                                            textColor: paleText,
                                                            color: confirm,
                                                            iceButtonImportance:
                                                                IceButtonImportance
                                                                    .mainAction,
                                                            iceButtonSize:
                                                                IceButtonSize
                                                                    .medium)
                                                      ],
                                                    ),
                                                  );
                                                });
                                          }
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }
                                        if (UserClient()
                                                .currentSkatingUser!
                                                .role ==
                                            UserRole.iceSkater) {
                                          await UserClient().changeRole(
                                              userID: UserClient()
                                                  .currentSkatingUser!
                                                  .uID!,
                                              role: UserRole.coach);
                                        }
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                                  content: Text(
                                                      savedModificationsSnack),
                                                  backgroundColor: confirm));
                                        }
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
