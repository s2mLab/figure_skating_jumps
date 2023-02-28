import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  Database? _database;
  static final LocalDbService _localDbService =
  LocalDbService._internal();

  // Dart's factory constructor allows us to get the same instance everytime this class is constructed
  // This helps having to refer to a static class .instance attribute for every call.
  factory LocalDbService() {
    return _localDbService;
  }

  LocalDbService._internal();

  // Based largely on : https://docs.flutter.dev/cookbook/persistence/sqlite
  Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
      version: 1,
      join(await getDatabasesPath(), 'ice_database.db'),
      onCreate: (db, version) {
        return db.execute('CREATE TABLE preferences(id INTEGER PRIMARY KEY, uID TEXT, deviceMacAddresses TEXT)');
      }
    );
  }
}