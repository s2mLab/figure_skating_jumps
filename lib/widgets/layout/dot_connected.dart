import 'package:figure_skating_jumps/constants/colors.dart';
import 'package:flutter/material.dart';

class DotConnected extends StatefulWidget {
  const DotConnected({Key? key}) : super(key: key);

  @override
  State<DotConnected> createState() => _DotConnectedState();
}

class _DotConnectedState extends State<DotConnected> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: dotConnection),
              child: Row(
                children: [
                  Image.asset('assets/images/connected_xdot.png'),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.all(16),
                          child: const Text(
                            'XSens Dot Thomas',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: discreetText, fontSize: 18),
                          )),
                      Container(
                        height: 24,
                        width: 200,
                        margin: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: primaryBackground),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'configuration',
                            style: TextStyle(color: discreetText),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16, top: 8),
                        height: 24,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: errorColor),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                          ),
                          child: const Text(
                            'Déconnection',
                            style: TextStyle(color: darkText),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                'Appareils connus à proximité',
                style: TextStyle(color: darkText, fontSize: 20),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Row(children: [
                  Container(
                    height: 48,
                    width: 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColorLight),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/images/xdot.png',
                    height: 40,
                  ),
                  const SizedBox(width: 16),
                  const Text('XSens Dot Jimmy')
                ])),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                'Mes appareils',
                style: TextStyle(color: darkText, fontSize: 20),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Row(children: [
                  Container(
                    height: 48,
                    width: 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColorLight),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/images/xdot.png',
                    height: 40,
                  ),
                  const SizedBox(width: 16),
                  const Text('XSens Dot Christophe')
                ])),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Row(children: [
                  Container(
                    height: 48,
                    width: 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: primaryColorLight),
                  ),
                  const SizedBox(width: 16),
                  Image.asset(
                    'assets/images/xdot.png',
                    height: 40,
                  ),
                  const SizedBox(width: 16),
                  const Text('XSens Dot David')
                ])),
          ],
        ));
  }
}
