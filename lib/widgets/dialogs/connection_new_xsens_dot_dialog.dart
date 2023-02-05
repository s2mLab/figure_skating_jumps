import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class ConnectionNewXSensDotDialog extends StatelessWidget {
  const ConnectionNewXSensDotDialog({super.key});

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
          const Text('TEST')
        ],
      ),
    );
  }
  
}