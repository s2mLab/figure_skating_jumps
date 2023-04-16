import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
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
          height: ReactiveLayoutHelper.getHeightFromFactor(200),
          width: ReactiveLayoutHelper.getWidthFromFactor(300),
          child: Form(
              key: _modificationInfoKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(passwordField, style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16))),
                    Expanded(
                        child: TextFormField(
                            style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
                            controller: _passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newPassValidator(value);
                            })),
                    const SizedBox(height: 24),
                    Text(passwordConfirmationField, style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16))),
                    Expanded(
                        child: TextFormField(
                            style: TextStyle(fontSize: ReactiveLayoutHelper.getHeightFromFactor(16)),
                            controller: _passwordConfirmationController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newPassConfirmValidator(
                                  value, _passwordController.text);
                            }))
                  ]))),
      actions: <Widget>[
        IceButton(text: cancelLabel, onPressed: () {
          Navigator.pop(context);
        }, textColor: errorColor, color: errorColorDark, iceButtonImportance: IceButtonImportance.secondaryAction, iceButtonSize: IceButtonSize.small),
        IceButton(text: modifyButton, onPressed: () => _confirmModification(context), textColor: paleText, color: primaryColor, iceButtonImportance: IceButtonImportance.mainAction, iceButtonSize: IceButtonSize.small),

      ],
    );
  }
}
