import 'package:figure_skating_jumps/exceptions/conflict_exception.dart';
import 'package:figure_skating_jumps/models/local_db/abstract_local_db_object.dart';
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
  /// Initializes the app by opening the local database.
  /// If the database does not exist, it is created.
  /// If the database has been updated, it applies all migrations.
  ///
  /// Returns void.
  Future<void> ensureInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    _database = await openDatabase(
        join(await getDatabasesPath(), _databaseName),
        version: _migrationScripts.length + 1, onCreate: (db, version) async {
      await _createDB(db);
    }, onUpgrade: (db, oldVersion, version) async {
      for (int i = 1; i <= _migrationScripts.length; i++) {
        await db.execute(_migrationScripts[i]!);
      }
    });
  }

  /// Inserts one object into the designated table.
  ///
  /// Parameters:
  /// - [object] : An object which inherits from [AbstractLocalDbObject].
  /// - [table] : A string indicating the table to insert into.
  ///
  /// Returns the id of the inserted object.
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

  /// Updates one object in the designated table.
  ///
  /// Parameters:
  /// - [object] : An object which inherits from [AbstractLocalDbObject].
  /// - [table] : A string indicating the table to update.
  ///
  /// Returns false if no object was updated.
  Future<bool> updateOne(AbstractLocalDbObject object, String table) async =>
      await _database.update(
        table,
        object.toMap(),
        where: 'id = ?',
        whereArgs: [object.id!],
        conflictAlgorithm: ConflictAlgorithm.rollback,
      ) ==
      1;

  /// Deletes one object from the designated table.
  ///
  /// Parameters:
  /// - [object] : An object which inherits from [AbstractLocalDbObject].
  /// - [table] : A string indicating the table to delete from.
  ///
  /// Returns true if the object was deleted.
  Future<bool> deleteOne(AbstractLocalDbObject object, String table) async =>
      await _database.delete(table, where: 'id = ?', whereArgs: [object.id!]) ==
      1;

  /// Deletes all entries in a table based on an equality check with one of the columns.
  ///
  /// Parameters:
  /// - [table] : A string indicating the table to delete from.
  /// - [column] : A string indicating the column to compare with.
  /// - [whereArg] : An object to compare to the value of the column.
  ///
  /// Returns how many entries were deleted.
  Future<int> deleteWhere(String table, String column, Object whereArg) async =>
      await _database.delete(
        table,
        where: '$column = ?',
        whereArgs: [whereArg],
      );

  /// Deletes all entries in a table.
  ///
  /// Parameters:
  /// - [table] : A string indicating the table to delete from.
  ///
  /// Returns how many entries were deleted.
  Future<int> deleteAll(String table) async =>
      await _database.delete(table, where: null);

  /// Reads all entries in a table.
  ///
  /// Parameters:
  /// - [table] : A string indicating the table to read from.
  ///
  /// Returns a list of the objects in a map format.
  Future<List<Map<String, dynamic>>> readAll(String table) async =>
      await _database.query(table);

  /// Reads one entry in a table based on its id.
  ///
  /// Parameters:
  /// - [id] : A string indicating the table to read from.
  /// - [table] : A string indicating the table to read from.
  ///
  /// Returns a map format of the object.
  Future<Map<String, dynamic>> readOne(String id, String table) async =>
      (await _database.query(table, where: 'id = ?', whereArgs: [id])).first;

  /// Reads all the entries in a table that pass an equality check on one of its columns.
  ///
  /// Parameters:
  /// - [table] : A string indicating the table to read from.
  /// - [column] : A string indicating the column to compare with.
  /// - [whereArg] : An object to compare to the value of the column.
  ///
  /// Returns a list of the objects in a map format.
  Future<List<Map<String, dynamic>>> readWhere(
          String table, String column, String whereArg) async =>
      (await _database
          .query(table, where: '$column = ?', whereArgs: [whereArg]));

  /// Creates the database using an initial configuration
  ///
  /// Parameters:
  /// - [db] : The [Database].
  Future<void> _createDB(Database db) async {
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
