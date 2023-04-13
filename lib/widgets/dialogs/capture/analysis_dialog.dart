import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/lang_fr.dart';

class AnalysisDialog extends StatelessWidget {
  const AnalysisDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        analyzingDataLabel,
        textAlign: TextAlign.center,
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                  width: 50,
                  child: LinearProgressIndicator(
                    color: primaryColor,
                    backgroundColor: discreetText,
                  )),
            ),
            Text(pleaseWaitLabel)
          ],
        )
      ],
    );
  }

}