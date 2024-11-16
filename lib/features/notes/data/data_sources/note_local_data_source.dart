import 'dart:io';
import 'package:note/core/error/exceptions.dart';
import 'package:note/core/services/database_services.dart';
import 'package:note/core/services/image_storage_services.dart';
import 'package:note/core/utils/logger.dart';

import 'package:note/features/notes/data/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class NoteLocalDataSource {
  Future<void> insertNoteLocally(NoteModel note);
  Future<void> updateNoteLocally(NoteModel note);
  Future<void> deleteNoteLocally(String id);
  Future<List<NoteModel>> fetchLocalNotes({required String userId});
  Future<List<NoteModel>> fetchLocalUnSyncedNotes();
  Future<List<NoteModel>> fetchDeletedNotes();
  Future<List<NoteModel>> fetchUpdatedNotes();
  Future<void> markNoteAsSynced(String noteId);
  Future<List<NoteModel>> fetchNotesByFolder(
      {required String folder, required String userId});
  Future<String> saveImageLocally(
      {required File imageFile, required String id});
  Future<void> deleteImageLocally({required File imageFile});
  Future<void> deleteImageLocallyFromPath({required String path});
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  // Delete a note from the local database
  @override
  Future<void> deleteNoteLocally(String id) async {
    try {
      await SQLiteService.instance
          .delete(table: 'notes', whereClause: 'id = ?', whereArgs: [id]);
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  // Fetch all local notes
  @override
  Future<List<NoteModel>> fetchLocalNotes({required String userId}) async {
    try {
      final jsonNotes = await SQLiteService.instance.fetchWhere(
        table: 'notes',
        whereClause: 'is_deleted = ? AND user_id = ?',
        whereArgs: [0, userId],
      );
      List<NoteModel> notes =
          jsonNotes.map((json) => NoteModel.fromJson(json)).toList();
      return notes;
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  // Insert a new note locally
  @override
  Future<void> insertNoteLocally(NoteModel note) async {
    try {
      final jsonNotes = await SQLiteService.instance.fetchWhere(
        table: 'notes',
        whereClause: 'user_id = ?',
        whereArgs: [note.id],
      );

      if (jsonNotes.isEmpty) {
        await SQLiteService.instance
            .insert(table: 'notes', data: note.toJson());
      } else {
        Log.info('id is exsist');
      }
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  // Mark a note as synced in the local database
  @override
  Future<void> markNoteAsSynced(String noteId) async {
    try {
      await SQLiteService.instance.update(
        table: 'notes',
        data: {'isSynced': 1},
        whereClause: 'id = ?',
        whereArgs: [noteId],
      );
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  // Update an existing note locally
  @override
  Future<void> updateNoteLocally(NoteModel note) async {
    try {
      Map<String, dynamic> updatedNoteData = {
        ...note.toJson(),
      };
      await SQLiteService.instance.update(
        table: 'notes',
        data: updatedNoteData,
        whereClause: 'id = ?',
        whereArgs: [note.id],
      );
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  // Fetch all local notes that haven't been synced yet
  @override
  Future<List<NoteModel>> fetchLocalUnSyncedNotes() async {
    try {
      final jsonNotes = await SQLiteService.instance.fetchWhere(
        table: 'notes',
        whereClause: 'is_synced = ?',
        whereArgs: [0],
      );
      return jsonNotes.map((json) => NoteModel.fromJson(json)).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<NoteModel>> fetchNotesByFolder(
      {required String folder, required String userId}) async {
    try {
      List<Map<String, dynamic>> jsonNotes =
          await SQLiteService.instance.getNotesByFolderName(folder, userId);
      List<NoteModel> notes =
          jsonNotes.map((json) => NoteModel.fromJson(json)).toList();
      return notes;
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<String> saveImageLocally(
      {required File imageFile, required String id}) async {
    String path = await ImageService.instance.saveImage(imageFile, id);
    return path;
  }

  @override
  Future<void> deleteImageLocally({required File imageFile}) async {
    await ImageService.instance.deleteImage(imageFile);
  }

  @override
  Future<void> deleteImageLocallyFromPath({required String path}) async {
    await ImageService.instance.deleteImageFromPath(path);
  }

  @override
  Future<List<NoteModel>> fetchDeletedNotes() async {
    try {
      final jsonNotes = await SQLiteService.instance.fetchWhere(
        table: 'notes',
        whereClause: 'is_deleted = ?',
        whereArgs: [1],
      );
      return jsonNotes.map((json) => NoteModel.fromJson(json)).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<List<NoteModel>> fetchUpdatedNotes() async {
    try {
      final jsonNotes = await SQLiteService.instance.fetchWhere(
        table: 'notes',
        whereClause: 'is_synced = ? AND is_updated = ? AND is_deleted = ?',
        whereArgs: [1, 1, 0],
      );
      return jsonNotes.map((json) => NoteModel.fromJson(json)).toList();
    } on DatabaseException catch (e) {
      throw CacheException(e.toString());
    }
  }
}
