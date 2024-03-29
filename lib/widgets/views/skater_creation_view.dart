import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/sizes.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/models/user_role.dart';
import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/tablet_topbar.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/layout/instruction_prompt.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
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
        appBar: ReactiveLayoutHelper.isTablet()
            ? const TabletTopbar(isUserDebuggingFeature: false)
                as PreferredSizeWidget
            : const Topbar(isUserDebuggingFeature: false),
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        drawerScrimColor: Colors.transparent,
        drawerEnableOpenDragGesture: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  (ReactiveLayoutHelper.isTablet()
                      ? bigTopbarHeight
                      : topbarHeight),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: primaryBackground,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ReactiveLayoutHelper.getHeightFromFactor(16),
                    horizontal:
                        ReactiveLayoutHelper.getWidthFromFactor(32, true)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: ReactiveLayoutHelper.getWidthFromFactor(8),
                          bottom: ReactiveLayoutHelper.getHeightFromFactor(24)),
                      child: const PageTitle(text: addASkaterTitle),
                    ),
                    const InstructionPrompt(
                        createAthleteExplainInfo, secondaryColor),
                    Expanded(
                      child: Column(children: [
                        Form(
                          key: _newSkaterKey,
                          child: Column(
                            children: [
                              TextFormField(
                                style: TextStyle(
                                    fontSize: ReactiveLayoutHelper
                                        .getHeightFromFactor(16)),
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
                                decoration: InputDecoration(
                                  labelText: surnameField,
                                  labelStyle: TextStyle(
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16),
                                      color: discreetText),
                                ),
                              ),
                              TextFormField(
                                style: TextStyle(
                                    fontSize: ReactiveLayoutHelper
                                        .getHeightFromFactor(16)),
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
                                decoration: InputDecoration(
                                  labelText: nameField,
                                  labelStyle: TextStyle(
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16),
                                      color: discreetText),
                                ),
                              ),
                              TextFormField(
                                style: TextStyle(
                                    fontSize: ReactiveLayoutHelper
                                        .getHeightFromFactor(16)),
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
                                decoration: InputDecoration(
                                  labelText: emailField,
                                  labelStyle: TextStyle(
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16),
                                      color: discreetText),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: ReactiveLayoutHelper.getHeightFromFactor(
                                    32)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (UserClient().currentSkatingUser!.role ==
                                    UserRole.iceSkater)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: ReactiveLayoutHelper
                                            .getHeightFromFactor(16)),
                                    child: const InstructionPrompt(
                                        warnAccountTypeChangeInfo,
                                        primaryColorLight),
                                  ),
                                IceButton(
                                    text: createAccountButton,
                                    onPressed: () async {
                                      String coachId =
                                          UserClient().currentSkatingUser!.uID!;
                                      if (_newSkaterKey.currentState != null &&
                                          _newSkaterKey.currentState!
                                              .validate()) {
                                        await _onCreateNewSkater(
                                            coachId, context);
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

  /// This function is called when a new skater is to be created for a coach.
  /// It creates a new skater, associates the skater with the coach, and adds the skater to the coach's list of trainees.
  ///
  /// Throws a [ConflictException] when a conflict occurs during the creation of the skater.
  ///
  /// Parameters:
  /// - [coachId] : The ID of the coach for whom the skater is to be created.
  /// - [context] : The [BuildContext] used to navigate to the list of athletes.
  Future<void> _onCreateNewSkater(String coachId, BuildContext context) async {
    // Ideally this would not use a try-catch as a condition-like structure
    try {
      UserClient().currentSkatingUser!.traineesID.add(await UserClient()
          .createAndLinkSkater(
              skaterEmail: _skaterEmail,
              coachId: coachId,
              firstName: _skaterSurname,
              lastName: _skaterName));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/ListAthletes',
            arguments: true);
      }
    } on ConflictException catch (e) {
      developer.log(e.devMessage);
      String? skatingUserUID = await UserClient()
          .linkExistingSkater(skaterEmail: _skaterEmail, coachId: coachId);
      if (skatingUserUID != null) {
        UserClient().currentSkatingUser!.traineesID.add(skatingUserUID);
      }
      if (mounted) {
        String messageToUser;
        if (_emailController.text == UserClient().currentAuthUser!.email) {
          messageToUser = ownProfileInListInfo;
        } else if (skatingUserUID == null) {
          messageToUser = athleteAlreadyInListInfo;
        } else {
          messageToUser = athleteAlreadyExistsInfo;
        }
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                          ReactiveLayoutHelper.getHeightFromFactor(8)),
                      child: Text(
                        messageToUser,
                        style: TextStyle(
                            fontSize:
                                ReactiveLayoutHelper.getHeightFromFactor(20)),
                      ),
                    ),
                    IceButton(
                        text: confirmLabel,
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/ListAthletes',
                              arguments: true);
                        },
                        textColor: paleText,
                        color: confirm,
                        iceButtonImportance: IceButtonImportance.mainAction,
                        iceButtonSize: IceButtonSize.medium)
                  ],
                ),
              );
            });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    if (UserClient().currentSkatingUser!.role == UserRole.iceSkater) {
      await UserClient().changeRole(
          userID: UserClient().currentSkatingUser!.uID!, role: UserRole.coach);
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(savedModificationsSnackInfo,
              style: TextStyle(
                  fontSize: ReactiveLayoutHelper.getHeightFromFactor(16))),
          backgroundColor: confirm));
    }
  }
}
