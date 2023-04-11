import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/exceptions/ice_exception.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../../enums/user_role.dart';
import '../../utils/reactive_layout_helper.dart';
import '../buttons/ice_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String _email = '';
  String _password = '';
  String _errorMessage = '';
  String _connectionLabelBtn = connectionButton;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _connectionInfoKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController(text: _email);
    _passwordController = TextEditingController(text: _password);
    super.initState();
  }

  Future<void> onConnection() async {
    if (_connectionInfoKey.currentState == null ||
        !_connectionInfoKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _connectionLabelBtn = connectingButton;
    });
    try {
      await UserClient().signIn(email: _email, password: _password);
      if (mounted) {
        UserClient().currentSkatingUser!.role == UserRole.coach
            ? Navigator.pushReplacementNamed(context, '/ListAthletes',
                arguments: false)
            : Navigator.pushReplacementNamed(context, '/Acquisitions',
                arguments: UserClient().currentSkatingUser);
      }
    } on IceException catch (e) {
      setState(() {
        _errorMessage = e.uiMessage;
      });
      debugPrint(e.devMessage);
    } catch (e) {
      _errorMessage = connectionImpossible;
    }
    setState(() {
      _connectionLabelBtn = connectionButton;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColorLight,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Center(
                child: SingleChildScrollView(
                    child: Column(
              children: [
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            ReactiveLayoutHelper.getWidthFromFactor(32),
                        vertical: ReactiveLayoutHelper.getHeightFromFactor(32)),
                    height: ReactiveLayoutHelper.getHeightFromFactor(100),
                    child: SvgPicture.asset(
                        'assets/vectors/blanc-logo-patinage-quebec.svg')),
                Container(
                    width: ReactiveLayoutHelper.getWidthFromFactor(300),
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            ReactiveLayoutHelper.getWidthFromFactor(32),
                        vertical: ReactiveLayoutHelper.getHeightFromFactor(32)),
                    decoration: BoxDecoration(
                      color: primaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [connectionShadow],
                    ),
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ReactiveLayoutHelper.getWidthFromFactor(16, true),
                            vertical: ReactiveLayoutHelper.getHeightFromFactor(32)),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ReactiveLayoutHelper
                                          .getHeightFromFactor(8)),
                              child: const PageTitle(text: loginTitle),
                            ),
                            Form(
                                key: _connectionInfoKey,
                                child: Column(children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _emailController,
                                    validator: (value) {
                                      return FieldValidators
                                          .loginEmailValidator(value);
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _email = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: email,
                                      labelStyle: TextStyle(
                                          fontSize:
                                              ReactiveLayoutHelper
                                                  .getHeightFromFactor(16),
                                          color: discreetText),
                                    ),
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize:  ReactiveLayoutHelper.getHeightFromFactor(16)),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _passwordController,
                                    obscureText: true,
                                    validator: (value) {
                                      return FieldValidators.loginPassValidator(
                                          value);
                                    },
                                    onChanged: (value) {
                                      setState(() {
                                        _password = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      labelText: password,
                                      labelStyle: TextStyle(
                                          fontSize: ReactiveLayoutHelper
                                                  .getHeightFromFactor(16),
                                          color: discreetText),
                                    ),
                                  )
                                ])),
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: ReactiveLayoutHelper.getWidthFromFactor(8), vertical: ReactiveLayoutHelper.getHeightFromFactor(8)),
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(
                                      color: errorColor, fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
                                )),
                            IceButton(
                                text: _connectionLabelBtn,
                                onPressed: () async {
                                  await onConnection();
                                },
                                textColor: paleText,
                                color: primaryColor,
                                iceButtonImportance:
                                    IceButtonImportance.mainAction,
                                iceButtonSize: IceButtonSize.medium),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: ReactiveLayoutHelper
                                          .getHeightFromFactor(8)),
                              child: IceButton(
                                  text: createAccount,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/CoachAccountCreation',
                                    );
                                  },
                                  textColor: primaryColor,
                                  color: primaryColor,
                                  iceButtonImportance:
                                      IceButtonImportance.secondaryAction,
                                  iceButtonSize: IceButtonSize.medium),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: IceButton(
                                  text: forgotPasswordButton,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/ForgotPasswordView',
                                    );
                                  },
                                  textColor: primaryColor,
                                  color: Colors.transparent,
                                  iceButtonImportance:
                                      IceButtonImportance.discreetAction,
                                  iceButtonSize: IceButtonSize.medium),
                            )
                          ],
                        ))),
              ],
            )))));
  }
}
