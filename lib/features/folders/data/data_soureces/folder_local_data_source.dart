import 'package:dartz/dartz.dart';
import 'package:note/core/error/exceptions.dart';
import 'package:note/core/services/database_services.dart';
import 'package:note/features/folders/data/models/folder_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class FolderLocalDataSource {
  Future<Unit> createFolder({required FolderModel folder});
  Future<Unit> updateFolder({required FolderModel folder});
  Future<Unit> deleteFolder({required String folderId});
  Future<List<FolderModel>> fetchAllFolders({required String userId});
  Future<List<FolderModel>> fetchLocalUnSyncedFolders();
  Future<List<FolderModel>> fetchLocalDeletedFolders();
  Future<List<FolderModel>> fetchLocalUpdatedFolders();
}

class FolderLocalDataSourceImple implements FolderLocalDataSource {
  @override
  Future<Unit> createFolder({required FolderModel folder}) async {
    try {
      await SQLiteService.instance
          .insert(table: 'folders', data: folder.toJson());
      return unit;
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<Unit> deleteFolder({required String folderId}) async {
    try {
      await SQLiteService.instance.delete(
          table: 'folders', whereClause: 'id = ?', whereArgs: [folderId]);
      return unit;
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<Unit> updateFolder({required FolderModel folder}) async {
    try {
      await SQLiteService.instance.update(
          table: 'folders',
          data: folder.toJson(),
          whereClause: 'id = ?',
          whereArgs: [folder.id]);
      return unit;
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<FolderModel>> fetchAllFolders({required String userId}) async {
    try {
      var jsonFolders = await SQLiteService.instance.fetchWhere(
        table: 'folders',
        whereClause: 'user_id = ?',
        whereArgs: [userId],
      );
      List<FolderModel> folders =
          jsonFolders.map((json) => FolderModel.fromJson(json)).toList();
      return folders;
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<FolderModel>> fetchLocalUnSyncedFolders() async {
    try {
      final jsonFolders = await SQLiteService.instance.fetchWhere(
        table: 'folders',
        whereClause: 'is_synced = ?',
        whereArgs: [0],
      );
      return jsonFolders.map((e) => FolderModel.fromJson(e)).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<FolderModel>> fetchLocalDeletedFolders() async {
    try {
      final jsonFolders = await SQLiteService.instance.fetchWhere(
        table: 'folders',
        whereClause: 'is_deleted = ?',
        whereArgs: [1],
      );
      return jsonFolders.map((e) => FolderModel.fromJson(e)).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<FolderModel>> fetchLocalUpdatedFolders() async {
    try {
      final jsonFolders = await SQLiteService.instance.fetchWhere(
        table: 'folders',
        whereClause: 'is_synced = ? AND is_updated = ? AND is_deleted = ?',
        whereArgs: [1, 1, 0],
      );
      return jsonFolders.map((e) => FolderModel.fromJson(e)).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }
}
