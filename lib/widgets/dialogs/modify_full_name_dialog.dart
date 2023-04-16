import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/models/firebase/skating_user.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
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
          height: ReactiveLayoutHelper.getHeightFromFactor(260),
          width: ReactiveLayoutHelper.getWidthFromFactor(300),
          child: Form(
              key: _modificationInfoKey,
              child: Column(children: [
                Row(
                  children: [
                    Text(firstNameField,
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
                    Text(lastNameField,style: TextStyle(
                        fontSize:
                        ReactiveLayoutHelper.getHeightFromFactor(16))),
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
        IceButton(text: cancelLabel, onPressed: () {
          Navigator.pop(context);
        }, textColor: errorColor, color: errorColorDark, iceButtonImportance: IceButtonImportance.secondaryAction, iceButtonSize: IceButtonSize.small),
        IceButton(text: modifyButton, onPressed: () => _confirmModification(context), textColor: paleText, color: primaryColor, iceButtonImportance: IceButtonImportance.mainAction, iceButtonSize: IceButtonSize.small),
      ],
    );
  }
}
