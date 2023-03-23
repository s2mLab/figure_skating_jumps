import 'package:flutter/material.dart';

enum JumpType {
  axel("A", Color.fromARGB(255, 235, 134, 255)),
  flip("F", Color.fromARGB(255, 119, 226, 226)),
  loop("Lo", Color.fromARGB(255, 255, 134, 134)),
  lutz("Lu", Color.fromARGB(255, 134, 136, 255)),
  salchow("S", Color.fromARGB(255, 255, 188, 134)),
  toeLoop("T", Color.fromARGB(255, 128, 221, 151)),
  unknown("-", Color.fromARGB(255, 173, 173, 173));

  const JumpType(this.abbreviation, this.color);

  final String abbreviation;
  final Color color;
}
