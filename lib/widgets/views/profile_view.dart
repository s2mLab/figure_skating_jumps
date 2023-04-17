import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/models/firebase/skating_user.dart';
import 'package:figure_skating_jumps/services/firebase/user_client.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/dialogs/confirm_remove_coach_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/modify_full_name_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/modify_password_dialog.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/tablet_topbar.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView> {
  final SkatingUser _currentUser = UserClient().currentSkatingUser!;
  List<SkatingUser> _coaches = [];
  bool _loading = true;

  _loadData() async {
    if (!_loading) return;
    _coaches = await _currentUser.getCoachesData();
    setState(() {
      _loading = false;
    });
  }

  removeCoachAction(String coachID) {
    UserClient()
        .unlinkSkaterAndCoach(coachId: coachID, skaterId: _currentUser.uID!)
        .then((value) {
      Navigator.pop(context);
      setState(() {
        _coaches.removeWhere((element) => element.uID! == coachID);
      });
    });
  }

  _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(
        appBar: ReactiveLayoutHelper.isTablet()
            ? const TabletTopbar(isUserDebuggingFeature: false)
                as PreferredSizeWidget
            : const Topbar(isUserDebuggingFeature: false),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.transparent,
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: Container(
            margin: EdgeInsets.symmetric(
                horizontal: ReactiveLayoutHelper.getWidthFromFactor(24, true),
                vertical: ReactiveLayoutHelper.getHeightFromFactor(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const PageTitle(text: profileTitle),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: ReactiveLayoutHelper.getHeightFromFactor(24),
                    horizontal: ReactiveLayoutHelper.getWidthFromFactor(16)),
                padding: EdgeInsets.all(
                    ReactiveLayoutHelper.getHeightFromFactor(16)),
                decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(UserClient().currentSkatingUser!.firstName,
                          style: TextStyle(
                              fontSize:
                                  ReactiveLayoutHelper.getHeightFromFactor(24),
                              color: darkText)),
                      Text(UserClient().currentSkatingUser!.lastName,
                          style: TextStyle(
                              fontSize:
                                  ReactiveLayoutHelper.getHeightFromFactor(20),
                              color: darkText)),
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              padding: EdgeInsets.all(
                                  ReactiveLayoutHelper.getHeightFromFactor(4)),
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ModifyFullName(
                                          refreshParent: _refresh);
                                    });
                              },
                              icon: const Icon(Icons.edit)))
                    ]),
              ),
              Container(
                  margin: EdgeInsets.only(
                      right: ReactiveLayoutHelper.getWidthFromFactor(24)),
                  alignment: Alignment.centerRight,
                  child: IceButton(
                      text: modifyPasswordButton,
                      onPressed: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return const ModifyPasswordDialog();
                            });
                      },
                      textColor: primaryColor,
                      color: primaryColor,
                      iceButtonImportance: IceButtonImportance.secondaryAction,
                      iceButtonSize: IceButtonSize.small)),
              Container(
                  margin: EdgeInsets.only(
                      right: ReactiveLayoutHelper.getHeightFromFactor(16),
                      left: ReactiveLayoutHelper.getHeightFromFactor(16),
                      top: ReactiveLayoutHelper.getHeightFromFactor(32)),
                  child: Text(
                    listCoachesTitle,
                    style: TextStyle(
                        color: darkText,
                        fontSize: ReactiveLayoutHelper.getHeightFromFactor(20)),
                  )),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(
                      ReactiveLayoutHelper.getHeightFromFactor(16)),
                  padding: EdgeInsets.symmetric(
                      vertical: ReactiveLayoutHelper.getHeightFromFactor(4)),
                  decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(10)),
                  child: _loading
                      ? const Center(
                          child: GFLoader(
                          size: 70,
                          loaderstrokeWidth: 5,
                        ))
                      : _coaches.isEmpty
                          ? Center(
                              child: Text(
                              noCoachesInfo,
                              style: TextStyle(
                                  fontSize:
                                      ReactiveLayoutHelper.getHeightFromFactor(
                                          16)),
                            ))
                          : ListView.builder(
                              itemCount: _coaches.length,
                              itemBuilder: (context, index) {
                                SkatingUser item = _coaches[index];
                                return Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: ReactiveLayoutHelper
                                          .getHeightFromFactor(4),
                                      horizontal: ReactiveLayoutHelper
                                          .getWidthFromFactor(8),
                                    ),
                                    padding: EdgeInsets.all(ReactiveLayoutHelper
                                        .getHeightFromFactor(8)),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${item.firstName} ${item.lastName}",
                                              style: TextStyle(
                                                  fontSize: ReactiveLayoutHelper
                                                      .getHeightFromFactor(
                                                          16))),
                                          IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ConfirmRemoveCoachDialog(
                                                          name: item.name,
                                                          confirmAction: () =>
                                                              removeCoachAction(
                                                                  item.uID!));
                                                    });
                                              },
                                              icon: const Icon(
                                                Icons.cancel_outlined,
                                                color: errorColor,
                                              ))
                                        ]));
                              }),
                ),
              )
            ])));
  }
}
