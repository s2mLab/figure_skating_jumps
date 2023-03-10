import 'package:flutter/material.dart';

class CapturesTab extends StatefulWidget {
  const CapturesTab({Key? key}) : super(key: key);

  @override
  _CapturesTabState createState() => _CapturesTabState();
}

class _CapturesTabState extends State<CapturesTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('capture'),
    );
  }
}
