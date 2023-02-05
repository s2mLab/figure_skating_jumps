import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ConnectionNewXSensDotDialog extends StatefulWidget {
  const ConnectionNewXSensDotDialog({super.key});
  @override
  State<ConnectionNewXSensDotDialog> createState() => _ConnectionNewXSensDotState();
}

class _ConnectionNewXSensDotState extends State<ConnectionNewXSensDotDialog>{
  int _connectionStep = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: primaryColorLight,
            ),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 18, bottom: 18),
                child: Text(
                  'Connecter un nouvel XSens DOT',
                  style: TextStyle(color: paleText, fontSize: 20),
                ),
              ),
            ),
          ),
          IndexedStack(
            index: _connectionStep,
            children: [
              TextButton(onPressed: toVerification, child: const Text('Searching...')),
              TextButton(onPressed: toConfiguration, child: const Text('Verifying...')),
              TextButton(onPressed: toSearch, child: const Text('Confirmed and configured!')),
            ],
          )
        ],
      ),
    );
  }

  void toSearch(){
    setState(() {
      _connectionStep = 0;
    });
  }

  void toVerification() {
    setState(() {
      _connectionStep = 1;
    });
  }

  void toConfiguration() {
    setState(() {
      _connectionStep = 2;
    });
  }
}