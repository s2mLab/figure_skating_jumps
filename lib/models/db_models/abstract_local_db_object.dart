import 'package:flutter/material.dart';

abstract class AbstractLocalDbObject {
  late int _id;

  int get id => _id;

  @protected
  set id(int value) {
    _id = id;
  }

  Map<String, dynamic> toMap();
}
