import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/enums/models/user_role.dart';
import 'package:figure_skating_jumps/exceptions/abstract_ice_exception.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            : Navigator.pushReplacementNamed(context, '/Captures',
                arguments: UserClient().currentSkatingUser);
      }
    } on AbstractIceException catch (e) {
      setState(() {
        _errorMessage = e.uiMessage;
      });
      debugPrint(e.devMessage);
    } catch (e) {
      _errorMessage = connectionImpossibleLabel;
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
                        horizontal: ReactiveLayoutHelper.getWidthFromFactor(32),
                        vertical: ReactiveLayoutHelper.getHeightFromFactor(32)),
                    height: ReactiveLayoutHelper.getHeightFromFactor(100),
                    child: SvgPicture.asset(
                        'assets/vectors/blanc-logo-patinage-quebec.svg')),
                Container(
                    width: ReactiveLayoutHelper.getWidthFromFactor(300),
                    margin: EdgeInsets.symmetric(
                        horizontal: ReactiveLayoutHelper.getWidthFromFactor(32),
                        vertical: ReactiveLayoutHelper.getHeightFromFactor(32)),
                    decoration: BoxDecoration(
                      color: primaryBackground,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [connectionShadow],
                    ),
                    child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: ReactiveLayoutHelper.getWidthFromFactor(
                                16, true),
                            vertical:
                                ReactiveLayoutHelper.getHeightFromFactor(32)),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          8)),
                              child: const PageTitle(text: loginTitle),
                            ),
                            Form(
                                key: _connectionInfoKey,
                                child: Column(children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontSize: ReactiveLayoutHelper
                                            .getHeightFromFactor(16)),
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
                                      labelText: emailField,
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
                                      labelText: passwordLabel,
                                      labelStyle: TextStyle(
                                          fontSize: ReactiveLayoutHelper
                                              .getHeightFromFactor(16),
                                          color: discreetText),
                                    ),
                                  )
                                ])),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        ReactiveLayoutHelper.getWidthFromFactor(
                                            8),
                                    vertical: ReactiveLayoutHelper
                                        .getHeightFromFactor(8)),
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(
                                      color: errorColor,
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16)),
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
                                  top: ReactiveLayoutHelper.getHeightFromFactor(
                                      8)),
                              child: IceButton(
                                  text: createAccountButton,
                                  onPressed: () {
                                    Navigator.pushNamed(
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
                                      '/ForgotPassword',
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:
                          ReactiveLayoutHelper.getWidthFromFactor(32, true)),
                  child: Text(dataMessageInfo,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize:
                              ReactiveLayoutHelper.getHeightFromFactor(10))),
                ),
              ],
            )))));
  }
}
