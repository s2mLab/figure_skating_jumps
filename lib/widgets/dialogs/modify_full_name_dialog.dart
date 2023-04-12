import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:flutter/material.dart';

class ModifyFullName extends StatelessWidget {
  ModifyFullName({Key? key, required dynamic Function() refreshParent})
      : _refreshParent = refreshParent,
        super(key: key);

  final Function() _refreshParent;
  static const _maxLength = 20;
  final SkatingUser _currentUser = UserClient().currentSkatingUser!;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _modificationInfoKey = GlobalKey<FormState>();

  _confirmModification(BuildContext context) async {
    if (_modificationInfoKey.currentState != null &&
        _modificationInfoKey.currentState!.validate()) {
      await UserClient().changeName(
          userID: _currentUser.uID!,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text);
      _refreshParent();
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    _firstNameController.text = _currentUser.firstName;
    _lastNameController.text = _currentUser.lastName;
    return AlertDialog(
      title: const Text(modificationTitle),
      content: SizedBox(
          height: 160,
          width: 300,
          child: Form(
              key: _modificationInfoKey,
              child: Column(children: [
                Row(
                  children: [
                    const Text(firstNameField),
                    Expanded(
                        child: TextFormField(
                            maxLength: _maxLength,
                            controller: _firstNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newNameValidator(value);
                            }))
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(lastNameField),
                    Expanded(
                        child: TextFormField(
                            maxLength: _maxLength,
                            controller: _lastNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newNameValidator(value);
                            }))
                  ],
                )
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
