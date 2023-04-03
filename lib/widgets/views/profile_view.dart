import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/models/skating_user.dart';
import 'package:figure_skating_jumps/services/user_client.dart';
import 'package:figure_skating_jumps/widgets/dialogs/confirm_cancel_custom_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/modify_full_name_dialog.dart';
import 'package:figure_skating_jumps/widgets/dialogs/modify_password_dialog.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/ice_drawer_menu.dart';
import 'package:figure_skating_jumps/widgets/layout/scaffold/topbar.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView> {
  bool _loading = true;
  final SkatingUser _currentUser = UserClient().currentSkatingUser!;

  _loadData() async {
    if (!_loading) return;
    await _currentUser.loadCoaches();
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
        _currentUser.coaches.removeWhere((element) => element.uID! == coachID);
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
        appBar: const Topbar(isUserDebuggingFeature: false),
        drawerEnableOpenDragGesture: false,
        drawerScrimColor: Colors.transparent,
        drawer: const IceDrawerMenu(isUserDebuggingFeature: false),
        body: Container(
            margin: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const PageTitle(text: profileTitle),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: cardBackground,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(UserClient().currentSkatingUser!.firstName,
                          style:
                              const TextStyle(fontSize: 24, color: darkText)),
                      Text(UserClient().currentSkatingUser!.lastName,
                          style:
                              const TextStyle(fontSize: 20, color: darkText)),
                      Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                              padding: const EdgeInsets.all(4),
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
              Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                      onTap: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return ModifyPassword();
                            });
                      },
                      child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                              color: primaryColorLight,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(8),
                          child: const Text(
                            modifyPassword,
                            style: TextStyle(color: paleText),
                          )))),
              Container(
                  margin: const EdgeInsets.only(right: 16, left: 16, top: 32),
                  child: const Text(
                    listCoaches,
                    style: TextStyle(color: darkText, fontSize: 20),
                  )),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                      color: cardBackground,
                      borderRadius: BorderRadius.circular(10)),
                  child: _loading
                      ? const Center(
                          child: GFLoader(
                          size: 70,
                          loaderstrokeWidth: 5,
                        ))
                      : _currentUser.coaches.isEmpty
                          ? const Center(child: Text(noCoaches))
                          : ListView.builder(
                              itemCount: _currentUser.coaches.length,
                              itemBuilder: (context, index) {
                                SkatingUser item = _currentUser.coaches[index];
                                return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4,
                                      horizontal: 8,
                                    ),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${item.firstName} ${item.lastName}"),
                                          IconButton(
                                              padding: EdgeInsets.zero,
                                              constraints:
                                                  const BoxConstraints(),
                                              onPressed: () async {
                                                await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return ConfirmCancelCustomDialog(
                                                          description:
                                                              "Voulez-vous retirer ${item.firstName} de votre liste d'entraineurs ?",
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
