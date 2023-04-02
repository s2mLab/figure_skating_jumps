import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:figure_skating_jumps/enums/helper_subject.dart';
import 'package:figure_skating_jumps/enums/ice_button_importance.dart';
import 'package:figure_skating_jumps/enums/ice_button_size.dart';
import 'package:figure_skating_jumps/widgets/buttons/ice_button.dart';
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
    return SimpleDialog(title: const Text(helperTitle), children: [
      Container(
        margin: const EdgeInsets.all(16),
        width: 600,
        height: 500,
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
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: 550,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: cardBackground,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(HelperSubject.values[index].title),
                              Icon(openedBox[index]
                                  ? Icons.expand_less
                                  : Icons.expand_more)
                            ]))),
                if (openedBox[index])
                  Column(children: [
                    Text(HelperSubject.values[index].description),
                    if (HelperSubject.values[index].direction != null)
                      Container(
                          margin: const EdgeInsets.all(8),
                          child: IceButton(
                              text: redirect,
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
      )
    ]);
  }
}