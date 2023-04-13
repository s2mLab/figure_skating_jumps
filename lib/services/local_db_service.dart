import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/models/db_models/abstract_local_db_object.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static const _databaseName = 'ice_database.db';
  static late Database _database;
  static final LocalDbService _localDbService = LocalDbService._internal();

  static const bluetoothDeviceTableName = "bluetoothDevices";
  static const localCapturesTableName = "localCaptures";
  static const activeSessionTableName = "activeSession";
  static const globalSettingsTableName = "globalSettings";

  final Map<int, String> _migrationScripts = {};

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
        join(await getDatabasesPath(), _databaseName),
        version: _migrationScripts.length + 1, onCreate: (db, version) async {
      await _createDB(db, version);
    }, onUpgrade: (db, oldVersion, version) async {
      for (int i = 1; i <= _migrationScripts.length; i++) {
        await db.execute(_migrationScripts[i]!);
      }
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
        whereArgs: [object.id!],
        conflictAlgorithm: ConflictAlgorithm.rollback,
      ) ==
      1;

  Future<bool> deleteOne(AbstractLocalDbObject object, String table) async =>
      await _database.delete(table, where: 'id = ?', whereArgs: [object.id!]) ==
      1;

  Future<int> deleteWhere(String table, String column, Object whereArg) async =>
      await _database.delete(
        table,
        where: '$column = ?',
        whereArgs: [whereArg],
      );

  Future<int> deleteAll(String table) async =>
      await _database.delete(table, where: null);

  Future<List<Map<String, dynamic>>> readAll(String table) async =>
      await _database.query(table);

  Future<Map<String, dynamic>> readOne(String id, String table) async =>
      (await _database.query(table, where: 'id = ?', whereArgs: [id])).first;

  Future<List<Map<String, dynamic>>> readWhere(
          String table, String column, String whereArg) async =>
      (await _database
          .query(table, where: '$column = ?', whereArgs: [whereArg]));

  Future<void> _createDB(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $bluetoothDeviceTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT, macAddress TEXT, name TEXT);');
    await db.execute(
        'CREATE TABLE $localCapturesTableName(id INTEGER PRIMARY KEY AUTOINCREMENT, captureID TEXT, path TEXT);');
    await db.execute(
        'CREATE TABLE $activeSessionTableName(id INTEGER PRIMARY KEY, email TEXT, password TEXT);');
    await db.execute(
        'CREATE TABLE $globalSettingsTableName(id INTEGER PRIMARY KEY, season TEXT);');
  }
}
