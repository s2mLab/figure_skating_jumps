import 'package:figure_skating_jumps/main.dart';
import 'package:figure_skating_jumps/widgets/screens/coach_account_creation_view.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';
import '../../enums/ice_button_importance.dart';
import '../../enums/ice_button_size.dart';
import '../buttons/ice_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String _email = '';
  String _password = '';
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _connectionInfoKey = GlobalKey<FormState>();

  @override
  void initState() {
    _emailController = TextEditingController(text: _email);
    _passwordController = TextEditingController(text: _password);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SingleChildScrollView(
                child: Center(
                    child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(32.0),
                    height: 100,
                    child: SvgPicture.asset(
                        'assets/vectors/blanc-logo-patinage-quebec.svg')),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(32.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                        margin: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: PageTitle(text: loginTitle),
                            ),
                            Form(
                                key: _connectionInfoKey,
                                child: Column(children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _emailController,
                                    onChanged: (value) {
                                      setState(() {
                                        _email = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: email,
                                      labelStyle: TextStyle(
                                          fontSize: 16, color: discreetText),
                                    ),
                                  ),
                                  TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _passwordController,
                                    obscureText: true,
                                    onChanged: (value) {
                                      setState(() {
                                        _password = value;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                      labelText: password,
                                      labelStyle: TextStyle(
                                          fontSize: 16, color: discreetText),
                                    ),
                                  )
                                ])),
                            const SizedBox(height: 32),
                            IceButton(
                                text: connectionButton,
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/',
                                  );
                                },
                                textColor: paleText,
                                color: primaryColor,
                                iceButtonImportance:
                                    IceButtonImportance.mainAction,
                                iceButtonSize: IceButtonSize.medium),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
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
                            )
                          ],
                        ))),
              ],
            )))));
  }
}
