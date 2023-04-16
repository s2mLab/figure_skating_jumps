import 'package:flutter/material.dart';

enum JumpType {
  axel("A", Color.fromARGB(255, 235, 134, 255)),
  salchow("S", Color.fromARGB(255, 255, 188, 134)),
  toeLoop("T", Color.fromARGB(255, 128, 221, 151)),
  loop("Lo", Color.fromARGB(255, 255, 134, 134)),
  flip("F", Color.fromARGB(255, 119, 226, 226)),
  lutz("Lz", Color.fromARGB(255, 134, 136, 255)),
  unknown(
      "-",
      Color.fromARGB(255, 173, 173,
          173)); // If new Jump Types are added in the future, unknown should always be last.

  const JumpType(this.abbreviation, this.color);

  final String abbreviation;
  final Color color;
}
