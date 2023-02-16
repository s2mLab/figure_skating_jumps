import 'package:figure_skating_jumps/constants/lang_fr.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../layout/topbar.dart';

class RawDataView extends StatelessWidget {
  const RawDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Topbar(isDebug: true),
      body: Column(
        children: [
          Text(rawDataTitle,
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold))
        ]
      ),
    );
  }

}