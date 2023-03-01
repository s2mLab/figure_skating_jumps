import 'package:figure_skating_jumps/models/db_models/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static late Database _database;
  static final LocalDbService _localDbService = LocalDbService._internal();

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
        version: 1, join(await getDatabasesPath(), 'ice_database.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE preferences(id INTEGER PRIMARY KEY, uID TEXT, deviceMacAddresses TEXT);'
          'CREATE TABLE deviceCustomNames(id INTEGER PRIMARY KEY, uID TEXT, deviceMacAddress TEXT, customName TEXT');
    });
  }

  Future<bool> insertUserPreferences(UserPreferences preferences) async {
    return await _database.insert(
          'preferences',
          preferences.toMap(),
          conflictAlgorithm: ConflictAlgorithm.rollback,
        ) !=
        0;
  }

  Future<bool> updateUserPreferences(UserPreferences preferences) async {
    return await _database.update(
      'preferences',
      preferences.toMap(),
      where: 'id = ?',
      whereArgs: [preferences.id],
      conflictAlgorithm: ConflictAlgorithm.rollback,
    ) !=
        0;
  }

  Future<bool> deleteUserPreferences(String uID) async {
    return await _database.delete(
      'preferences',
      where: 'uID = ?',
      whereArgs: [uID],
    ) !=
        0;
  }

  Future<List<UserPreferences>> readAllUserPreferences() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('preferences');
    return List.generate(maps.length, (i) {
      return UserPreferences(
        id: maps[i]['id'],
        uID: maps[i]['uID'],
        deviceMacAddresses: maps[i]['deviceMacAddresses'],
      );
    });
  }

  Future<UserPreferences> readUserPreferences(String uID) async {
    final List<Map<String, dynamic>> maps = await _database
        .query('preferences', where: 'uID = ?', whereArgs: [uID]);
    return List.generate(maps.length, (i) {
      return UserPreferences(
        id: maps[i]['id'],
        uID: maps[i]['uID'],
        deviceMacAddresses: maps[i]['deviceMacAddresses'],
      );
    }).first;
  }
}
