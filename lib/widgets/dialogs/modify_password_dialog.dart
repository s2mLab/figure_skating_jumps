import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:flutter/material.dart';

class ModifyPassword extends StatelessWidget {
  ModifyPassword({Key? key}) : super(key: key);

  final SkatingUser _currentUser = UserClient().currentSkatingUser!;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final _modificationInfoKey = GlobalKey<FormState>();

  _confirmModification(BuildContext context) async {
    if (_modificationInfoKey.currentState != null &&
        _modificationInfoKey.currentState!.validate()) {
      await UserClient().changePassword(
          userID: _currentUser.uID!, password: _passwordController.text);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(modificationPasswordTitle),
      content: SizedBox(
          height: 200,
          width: 300,
          child: Form(
              key: _modificationInfoKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(passwordField),
                    Expanded(
                        child: TextFormField(
                            controller: _passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newPassValidator(value);
                            })),
                    const SizedBox(height: 24),
                    const Text(passwordConfirmationField),
                    Expanded(
                        child: TextFormField(
                            controller: _passwordConfirmationController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newPassConfirmValidator(
                                  value, _passwordController.text);
                            }))
                  ]))),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => _confirmModification(context),
          child: const Text(modifyButton),
        ),
      ],
    );
  }
}
