import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
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
      title: Text(modificationTitle,
          style: TextStyle(
              fontSize: ReactiveLayoutHelper.getHeightFromFactor(16))),
      content: SizedBox(
          height: ReactiveLayoutHelper.getHeightFromFactor(160),
          width: ReactiveLayoutHelper.getWidthFromFactor(300),
          child: Form(
              key: _modificationInfoKey,
              child: Column(children: [
                Row(
                  children: [
                    Text(firstName,
                        style: TextStyle(
                            fontSize:
                                ReactiveLayoutHelper.getHeightFromFactor(16))),
                    Expanded(
                        child: TextFormField(
                            style: TextStyle(
                                fontSize:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        16)),
                            maxLength: _maxLength,
                            controller: _firstNameController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newNameValidator(value);
                            }))
                  ],
                ),
                SizedBox(height: ReactiveLayoutHelper.getHeightFromFactor(8)),
                Row(
                  children: [
                    const Text(lastName),
                    Expanded(
                        child: TextFormField(
                            style: TextStyle(
                                fontSize:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        16)),
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
          child: Text(cancel, style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16))),
        ),
        TextButton(
          onPressed: () => _confirmModification(context),
          child: Text(confirmLabel, style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16))),
        ),
      ],
    );
  }
}
