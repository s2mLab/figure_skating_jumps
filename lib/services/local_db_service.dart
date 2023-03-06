import 'package:figure_skating_jumps/models/db_models/abstract_local_db_object.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static const _databaseName = 'ice_database.db';
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
        version: 1, join(await getDatabasesPath(), _databaseName),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE preferences(id INTEGER PRIMARY KEY, uID TEXT, deviceMacAddresses TEXT);'
          'CREATE TABLE deviceCustomNames(id INTEGER PRIMARY KEY, uID TEXT, deviceMacAddress TEXT, customName TEXT');
    });
  }

  Future<bool> insertOne(AbstractLocalDbObject object, String table) async =>
      await _database.insert(
        table,
        object.toMap(),
        conflictAlgorithm: ConflictAlgorithm.rollback,
      ) !=
      0;

  Future<bool> updateOne(AbstractLocalDbObject object, String table) async =>
      await _database.update(
        table,
        object.toMap(),
        where: 'id = ?',
        whereArgs: [object.id],
        conflictAlgorithm: ConflictAlgorithm.rollback,
      ) !=
      0;

  Future<bool> deleteOne(AbstractLocalDbObject object, String table) async =>
      await _database.delete(
        table,
        where: 'id = ?',
        whereArgs: [object.id],
      ) !=
      0;

  Future<List<Map<String, dynamic>>> readAll(String table) async =>
      await _database.query(table);

  Future<Map<String, dynamic>> readOne(String id, String table) async =>
      (await _database.query(table, where: 'id = ?', whereArgs: [id])).first;
}
