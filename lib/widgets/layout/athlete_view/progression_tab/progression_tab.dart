import 'package:flutter/material.dart';

class ProgressionTab extends StatelessWidget{
  const ProgressionTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child:
        Column(
          children: [Row(children: [Text("a")],)],
        )),
      ],
    );
  }

}