import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/helper_subject.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button/ice_button_size.dart';
import 'package:figure_skating_jumps/utils/reactive_layout_helper.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
import 'package:figure_skating_jumps/widgets/titles/page_title.dart';
import 'package:flutter/material.dart';

class HelperDialog extends StatefulWidget {
  const HelperDialog({Key? key}) : super(key: key);

  @override
  State<HelperDialog> createState() {
    return _HelperDialogState();
  }
}

class _HelperDialogState extends State<HelperDialog> {
  final List<bool> openedBox =
      List<bool>.generate(HelperSubject.values.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: const PageTitle(text:helperTitle),
        children: [
          Container(
            margin:
                EdgeInsets.all(ReactiveLayoutHelper.getHeightFromFactor(16)),
            width: ReactiveLayoutHelper.getHeightFromFactor(600),
            height: ReactiveLayoutHelper.getHeightFromFactor(500),
            child: ListView.builder(
                itemCount: HelperSubject.values.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            openedBox[index] = !openedBox[index];
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        8)),
                            width: ReactiveLayoutHelper.getWidthFromFactor(550),
                            padding: EdgeInsets.all(
                                ReactiveLayoutHelper.getHeightFromFactor(8)),
                            decoration: BoxDecoration(
                                color: cardBackground,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(HelperSubject.values[index].title,
                                      style: TextStyle(
                                          fontSize: ReactiveLayoutHelper
                                              .getHeightFromFactor(16))),
                                  Icon(openedBox[index]
                                      ? Icons.expand_less
                                      : Icons.expand_more)
                                ]))),
                    if (openedBox[index])
                      Column(children: [
                        Text(HelperSubject.values[index].description,
                            style: TextStyle(
                                fontSize:
                                    ReactiveLayoutHelper.getHeightFromFactor(
                                        16))),
                        if (HelperSubject.values[index].direction != null)
                          Container(
                              margin: EdgeInsets.all(
                                  ReactiveLayoutHelper.getHeightFromFactor(8)),
                              child: IceButton(
                                  text: redirectButton,
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context,
                                        HelperSubject.values[index].direction!);
                                  },
                                  textColor: primaryColor,
                                  color: primaryColor,
                                  iceButtonImportance:
                                      IceButtonImportance.secondaryAction,
                                  iceButtonSize: IceButtonSize.medium))
                      ])
                  ]);
                }),
          ),
          Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ReactiveLayoutHelper.getWidthFromFactor(32)),
              child: Text(
                "Cette application a été développée par Thomas Beauchamp, Jimmy Bell, David Saikali et Christophe St-Georges en Hiver 2023 dans le cadre d'un projet intégrateur de fin de baccaulauréat en génie logiciel à Polytechnique Montréal.",
                style: TextStyle(
                    fontSize: ReactiveLayoutHelper.getHeightFromFactor(10)),
              ))
        ]);
  }
}
