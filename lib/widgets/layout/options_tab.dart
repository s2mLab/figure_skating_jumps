import 'package:flutter/material.dart';

class OptionsTab extends StatefulWidget {
  const OptionsTab({Key? key}) : super(key: key);

  @override
  State<OptionsTab> createState() {
    return _OptionsTabState();
  }
}

class _OptionsTabState extends State<OptionsTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('option'),
    );
  }
}
