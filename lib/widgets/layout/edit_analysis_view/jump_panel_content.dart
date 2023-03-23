import 'package:flutter/material.dart';

import '../../../models/jump.dart';

class JumpPanelContent extends StatefulWidget {
  final String jumpID;
  const JumpPanelContent({super.key, required this.jumpID, required void Function(Jump j) onModified});

  @override
  State<JumpPanelContent> createState() => _JumpPanelContentState();

}

class _JumpPanelContentState extends State<JumpPanelContent> {
  Jump? j;

  @override
  Widget build(BuildContext context) {
    return Text(widget.jumpID);
  }

}