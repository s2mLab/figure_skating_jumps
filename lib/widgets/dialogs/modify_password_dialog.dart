import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/models/firebase/skating_user.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:flutter/material.dart';

class ModifyPasswordDialog extends StatefulWidget {
  const ModifyPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ModifyPasswordDialog> createState() => _ModifyPasswordDialogState();
}

class _ModifyPasswordDialogState extends State<ModifyPasswordDialog> {
  final SkatingUser _currentUser = UserClient().currentSkatingUser!;
  final TextEditingController _previousPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final _modificationInfoKey = GlobalKey<FormState>();

  String _errorMessage = "";

  /// Confirm a password modification by checking the validity of the new and previous passwords
  /// and sending a request to the UserClient to change the password if they are valid.
  ///
  /// Parameters:
  /// - [context]: the context of the current widget tree.
  _confirmModification(BuildContext context) async {
    if (_modificationInfoKey.currentState != null &&
        _modificationInfoKey.currentState!.validate()) {
      try {
        await UserClient().changePassword(
            email: _currentUser.email,
            oldPassword: _previousPasswordController.text,
            password: _passwordController.text);
        if (context.mounted) Navigator.of(context).pop();
      } catch (e) {
        setState(() {
          _errorMessage = errorModification;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(modificationPasswordTitle),
      content: SizedBox(
          height: ReactiveLayoutHelper.getHeightFromFactor(350),
          width: ReactiveLayoutHelper.getWidthFromFactor(300),
          child: Form(
              key: _modificationInfoKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: ReactiveLayoutHelper.getHeightFromFactor(24)),
                    Text(previousPasswordField,
                        style: TextStyle(
                            fontSize:
                                ReactiveLayoutHelper.getHeightFromFactor(16))),
                    Expanded(
                        child: TextFormField(
                            obscureText: true,
                            style: TextStyle(
                                fontSize:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        16)),
                            controller: _previousPasswordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.loginPassValidator(value);
                            })),
                    Text(passwordField,
                        style: TextStyle(
                            fontSize:
                                ReactiveLayoutHelper.getHeightFromFactor(16))),
                    Expanded(
                        child: TextFormField(
                            obscureText: true,
                            style: TextStyle(
                                fontSize:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        16)),
                            controller: _passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newPassValidator(value);
                            })),
                    const SizedBox(height: 24),
                    Text(passwordConfirmationField,
                        style: TextStyle(
                            fontSize:
                                ReactiveLayoutHelper.getHeightFromFactor(16))),
                    Expanded(
                        child: TextFormField(
                            obscureText: true,
                            style: TextStyle(
                                fontSize:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        16)),
                            controller: _passwordConfirmationController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return FieldValidators.newPassConfirmValidator(
                                  value, _passwordController.text);
                            })),
                    Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: Text(_errorMessage,
                            style: TextStyle(
                                color: errorColor,
                                fontSize:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        16)))),
                  ]))),
      actions: <Widget>[
        IceButton(
            text: cancelLabel,
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: errorColor,
            color: errorColorDark,
            iceButtonImportance: IceButtonImportance.secondaryAction,
            iceButtonSize: IceButtonSize.small),
        IceButton(
            text: modifyButton,
            onPressed: () => _confirmModification(context),
            textColor: paleText,
            color: primaryColor,
            iceButtonImportance: IceButtonImportance.mainAction,
            iceButtonSize: IceButtonSize.small),
      ],
    );
  }
}
