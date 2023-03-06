import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/colors.dart';
import '../../constants/lang_fr.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String _coachEmail = '';
  String _coachPassword = '';
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController(text: _coachEmail);
    _passwordController = TextEditingController(text: _coachPassword);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: SingleChildScrollView(
            child: Column(
          children: [
            const SizedBox(height: 150),
            Container(
                margin: const EdgeInsets.all(32.0),
                height: 120,
                child: SvgPicture.asset(
                    'assets/vectors/blanc-logo-patinage-quebec.svg')),
            Container(
                // height: 200,
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
                            labelStyle:
                                TextStyle(fontSize: 16, color: discreetText),
                          ),
                        ),
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
                            labelStyle:
                                TextStyle(fontSize: 16, color: discreetText),
                          ),
                        ),
                      ],
                    )))
          ],
        )));
  }

  String? _passValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return pleaseFillField;
    }
    if (value.length < 10) {
      return addCharacters;
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
}
