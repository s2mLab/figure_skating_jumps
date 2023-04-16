import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/constants/styles.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/utils/field_validators.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});

  final TextEditingController _emailController = TextEditingController();
  final _forgotPasswordInfoKey = GlobalKey<FormState>();

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
                    margin: EdgeInsets.all(
                        ReactiveLayoutHelper.getHeightFromFactor(32)),
                    height: ReactiveLayoutHelper.getHeightFromFactor(100),
                    child: SvgPicture.asset(
                        'assets/vectors/blanc-logo-patinage-quebec.svg')),
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            ReactiveLayoutHelper.getWidthFromFactor(32, true),
                        vertical: ReactiveLayoutHelper.getHeightFromFactor(32)),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                              child: const PageTitle(text: forgotPasswordTitle),
                            ),
                            Form(
                                key: _forgotPasswordInfoKey,
                                child: TextFormField(
                                  style: TextStyle(
                                      fontSize: ReactiveLayoutHelper
                                          .getHeightFromFactor(16)),
                                  keyboardType: TextInputType.emailAddress,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _emailController,
                                  validator: (value) {
                                    return FieldValidators.newEmailValidator(
                                        value);
                                  },
                                  decoration: InputDecoration(
                                    labelText: emailField,
                                    labelStyle: TextStyle(
                                        fontSize: ReactiveLayoutHelper
                                            .getHeightFromFactor(16),
                                        color: discreetText),
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: ReactiveLayoutHelper.getHeightFromFactor(
                                      32)),
                              child: IceButton(
                                  text: sendEmailButton,
                                  onPressed: () async {
                                    if (_forgotPasswordInfoKey.currentState ==
                                            null ||
                                        !_forgotPasswordInfoKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                    try {
                                      await UserClient().resetPassword(
                                          email: _emailController.text);
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    } finally {
                                      Fluttertoast.showToast(
                                          msg: forgotPasswordInfo);
                                      if(context.mounted) {
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  textColor: paleText,
                                  color: primaryColor,
                                  iceButtonImportance:
                                      IceButtonImportance.mainAction,
                                  iceButtonSize: IceButtonSize.medium),
                            ),
                          ],
                        ))),
              ],
            )))));
  }
}
