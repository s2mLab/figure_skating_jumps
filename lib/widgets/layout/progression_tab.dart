import 'package:flutter/material.dart';

class ProgressionTab extends StatefulWidget {
  const ProgressionTab({Key? key}) : super(key: key);

  @override
  _ProgressionTabState createState() => _ProgressionTabState();
}

class _ProgressionTabState extends State<ProgressionTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('progression'),
    );
  }
}
