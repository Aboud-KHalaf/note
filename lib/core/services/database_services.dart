import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteService {
  // Singleton instance
  static final SQLiteService instance = SQLiteService._init();
  static Database? _database;

  // Private constructor
  SQLiteService._init();

  // Getter to access the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes_app_database.db');
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String dbName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create the database schema
  Future _createDB(Database db, int version) async {
    // Constants for column types
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const dateType = 'TEXT NOT NULL';

    // Create notes table
    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        color $intType,
        user_id $textType,
        title $textType,
        content $textType,
        image_url $textType,
        folders $textType,
        uploaded_at $dateType,
        is_synced $boolType,
        is_updated $boolType,
        is_deleted $boolType
      )
    ''');

    // Create folders table
    await db.execute('''
      CREATE TABLE folders (
        id $idType,
        user_id $textType,
        name $textType,
        description $textType,
        is_synced $boolType,
        is_updated $boolType,
        is_deleted $boolType,
        color $intType
      )
    ''');
  }

  // Insert data into the table
  Future<void> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    await db.insert(table, data);
  }

  // Fetch records with conditions (e.g., unsynced notes)
  Future<List<Map<String, dynamic>>> fetchWhere({
    required String table,
    required String whereClause,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: (table == "notes") ? 'uploaded_at DESC' : null,
    );
  }

  // Update a record in the table
  Future<int> update({
    required String table,
    required Map<String, dynamic> data,
    required String whereClause,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, data,
        where: whereClause, whereArgs: whereArgs);
  }

  // Delete a record
  Future<int> delete({
    required String table,
    required String whereClause,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  // Close the database connection
  Future close() async {
    final db = await database;
    db.close();
  }

  // Method to fetch all folder names
  Future<List<String>> getFolderNames() async {
    final db = await database;
    final result = await db.query('folders');
    // Extracting 'name' column values as a list of strings
    return result.map((row) => row['name'] as String).toList();
  }

  // Method to fetch notes containing a specific word in the folders column
  Future<List<Map<String, dynamic>>> getNotesByFolderName(
      String folderName, String userId) async {
    final db = await database;
    return await db.query(
      'notes',
      where: "folders LIKE ? AND is_deleted = ? AND user_id = ?",
      whereArgs: [
        '%$folderName%',
        0,
        userId
      ], // SQL pattern matching for partial match
    );
  }
}
