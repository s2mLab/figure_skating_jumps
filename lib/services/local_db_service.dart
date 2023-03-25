import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/models/db_models/abstract_local_db_object.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static const _databaseName = 'ice_database.db';
  static late Database _database;
  static final LocalDbService _localDbService = LocalDbService._internal();

  static const deviceNamesTableName = "deviceNames";

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
        join(await getDatabasesPath(), _databaseName), onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $deviceNamesTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, userID TEXT, deviceMacAddress TEXT, customName TEXT);');
    });
  }

  Future<int> insertOne(AbstractLocalDbObject object, String table) async {
    int id = await _database.insert(
      table,
      object.toMap(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
    if (id == 0) {
      throw ConflictException();
    }
    return id;
  }

  Future<bool> updateOne(AbstractLocalDbObject object, String table) async =>
      await _database.update(
        table,
        object.toMap(),
        where: 'id = ?',
        whereArgs: [object.id],
        conflictAlgorithm: ConflictAlgorithm.rollback,
      ) ==
      1;

  Future<bool> deleteOne(AbstractLocalDbObject object, String table) async =>
      await _database.delete(
        table,
        where: 'id = ?',
        whereArgs: [object.id],
      ) ==
      1;

  Future<List<Map<String, dynamic>>> readAll(String table) async =>
      await _database.query(table);

  Future<Map<String, dynamic>> readOne(String id, String table) async =>
      (await _database.query(table, where: 'id = ?', whereArgs: [id])).first;

  Future<List<Map<String, dynamic>>> readWhere(
          String table, String column, String whereArg) async =>
      (await _database
          .query(table, where: '$column = ?', whereArgs: [whereArg]));
}
