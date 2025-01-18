import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/services/encryption_services.dart';
import '../../../../core/services/network_services.dart';
import '../../../../core/services/shared_preferences_services.dart';
import '../../../../core/utils/logger.dart';
import '../data_sources/note_local_data_source.dart';
import '../data_sources/note_remote_data_source.dart';
import '../models/note_model.dart';
import '../../domain/repository/note_repository.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/entities/required_data_entity.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource noteRemoteDataSource;
  final NoteLocalDataSource noteLocalDataSource;
  final InternetConnectivity internetConnectivity;

  NoteRepositoryImpl(
      {required this.internetConnectivity,
      required this.noteLocalDataSource,
      required this.noteRemoteDataSource,
      r});
  @override
  ResultFuture<List<NoteModel>> fetchAllLocalNotes() async {
    try {
      SharedPreferencesService sps = SharedPreferencesService();
      String id = await sps.getUserId() ?? "";
      List<NoteModel> notes =
          await noteLocalDataSource.fetchLocalNotes(userId: id);

      return right(notes);
    } on CacheException catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  ResultFuture<NoteEntity> insertNote({
    required RequiredDataEntity data,
  }) async {
    try {
      String idd = data.id == '' ? const Uuid().v1() : data.id;
      String? imagePath;
      if (data.image != null) {
        imagePath = await noteLocalDataSource.saveImageLocally(
            imageFile: data.image!, id: idd);
      }

      Log.cyan(idd);
      NoteModel noteModel = NoteModel(
        id: idd,
        color: data.color,
        userId: data.userId,
        imageUrl: imagePath ?? '',
        title: data.title,
        content: data.content,
        folders: data.folders,
        uploadedAt: DateTime.now(),
        isSynced: 0,
        isDeleted: 0,
        isUpdated: 0,
      );

      noteLocalDataSource.insertNoteLocally(noteModel);

      return right(noteModel);
    } on CacheException catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Unit> deleteNote({required NoteModel note}) async {
    try {
      if (note.isSynced == 0) {
        if (note.imageUrl != '') {
          noteLocalDataSource.deleteImageLocallyFromPath(path: note.imageUrl!);
        }
        await noteLocalDataSource.deleteNoteLocally(note.id);
      } else {
        NoteModel noteModel = note.copyWith(isDeleted: 1);
        await noteLocalDataSource.updateNoteLocally(noteModel);
      }
      return right(unit);
    } on CacheException catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Unit> updateNote({required RequiredDataEntity data}) async {
    try {
      String? imagePath;

      if (data.image != null) {
        imagePath = await noteLocalDataSource.saveImageLocally(
            imageFile: data.image!, id: data.id);
      }
      NoteModel noteModel = NoteModel(
        id: data.id,
        color: data.color,
        userId: data.userId,
        imageUrl: imagePath ?? '',
        title: data.title,
        content: data.content,
        folders: data.folders,
        uploadedAt: DateTime.now(),
        isSynced: data.inSynced ?? 0,
        isDeleted: 0,
        isUpdated: 1,
      );
      await noteLocalDataSource.updateNoteLocally(noteModel);
      return right(unit);
    } on CacheException catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  ResultFuture<List<NoteEntity>> fetchNotesByFolder(
      {required String folderName}) async {
    try {
      SharedPreferencesService sps = SharedPreferencesService();
      String id = await sps.getUserId() ?? "";
      List<NoteModel> notes = await noteLocalDataSource.fetchNotesByFolder(
          folder: folderName, userId: id);
      return right(notes);
    } on CacheException catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Unit> synceNotes() async {
    bool isConnected = await internetConnectivity.isConnected();

    if (isConnected) {
      //
      await _syncDeletedNotes();
      await _syncUpdatedNotes();
      await _uploadUnSyncedNotes();
      //
      return right(unit);
    } else {
      Log.error("not connected");
      return left(const ServerFailure('No internet'));
    }
  }

  @override
  ResultFuture<Unit> fetchAllRemoteNotes() async {
    try {
      List<NoteModel> notes = await noteRemoteDataSource.fetchAllNotes();
      final caesarCipher = EncryptionFactory.create(EncryptionType.caesar);

      for (NoteModel note in notes) {
        if (note.imageUrl != null && note.imageUrl!.isNotEmpty) {
          Log.error("errore");
          // File image = await noteRemoteDataSource.downloadImage(note: note);
        }

        String caesarText = note.content;
        String caesarKey = note.uploadedAt.second.toString();
        NoteModel noteModel = note.copyWith(
          isSynced: 1,
          imageUrl: '',
          content: caesarCipher.decrypt(
            text: caesarText,
            key: caesarKey,
          ),
        );

        Log.error(note.title);
        noteLocalDataSource.insertNoteLocally(noteModel);
        Log.error(note.imageUrl!);
      }
      return right(unit);
    } on CacheException catch (e) {
      return left(CacheFailure(e.toString()));
    } on ServerException catch (e) {
      return left(ServerFailure(e.toString()));
    } catch (e) {
      return left(const UnknownFailure());
    }
  }

  Future<void> _uploadUnSyncedNotes() async {
    Log.warning("connected ... upload start");
    final List<NoteModel> unsyncedNotes =
        await noteLocalDataSource.fetchLocalUnSyncedNotes();

    final caesarCipher = EncryptionFactory.create(EncryptionType.caesar);
    for (NoteModel note in unsyncedNotes) {
      // encrypt
      try {
        String caesarText = note.content;
        String caesarKey = note.uploadedAt.second.toString();
        NoteModel noteModel = note.copyWith(
            content: caesarCipher.encrypt(
          text: caesarText,
          key: caesarKey,
        ));
        //
        if (note.imageUrl != null && note.imageUrl != '') {
          Log.cyan(note.imageUrl!);
          final String imageUrl = await noteRemoteDataSource.uploadImage(
              note: note, image: File(note.imageUrl!));

          noteModel = noteModel.copyWith(imageUrl: imageUrl);
        }
        //

        bool result = await noteRemoteDataSource.uploadNote(note: noteModel);

        if (result == true) {
          // Mark the note as synced in the local database
          await noteLocalDataSource
              .updateNoteLocally(noteModel.copyWith(isSynced: 1));
          Log.info("${note.title} upload success");
        }
      } catch (e) {
        Log.error("${note.title} upload failed because ${e.toString()}");
      }
    }
  }

  Future<void> _syncDeletedNotes() async {
    Log.warning("sync Deleted Notes start");
    final List<NoteModel> deletedNotes =
        await noteLocalDataSource.fetchDeletedNotes();

    for (var note in deletedNotes) {
      Log.error(note.title);

      try {
        NoteModel noteModel = note;
        if (note.imageUrl != null && note.imageUrl != '') {
          await noteRemoteDataSource.deleteImage(note: note);
        }

        bool result =
            await noteRemoteDataSource.deleteNote(noteId: noteModel.id);

        if (result == true) {
          // Mark the note as synced in the local database
          await noteLocalDataSource.deleteNoteLocally(noteModel.id);
          Log.info("${note.title} deleted success");
        }
      } catch (e) {
        Log.error("${note.title} deleted failed because ${e.toString()}");
      }
    }
  }

  Future<void> _syncUpdatedNotes() async {
    Log.warning("sync updated Notes start");
    final List<NoteModel> updatedNotes =
        await noteLocalDataSource.fetchUpdatedNotes();
    final caesarCipher = EncryptionFactory.create(EncryptionType.caesar);

    for (var note in updatedNotes) {
      Log.cyan(note.title);
      try {
        String caesarText = note.content;
        String caesarKey = note.uploadedAt.second.toString();
        NoteModel noteModel = note;
        if (note.imageUrl != null && note.imageUrl != '') {
          final String imageUrl = await noteRemoteDataSource.updateImage(
              note: note, newImage: File(note.imageUrl!));

          noteModel = noteModel.copyWith(imageUrl: imageUrl);
        }

        bool result = await noteRemoteDataSource.updateNote(
            note: noteModel.copyWith(content: caesarText));

        if (result == true) {
          await noteLocalDataSource
              .updateNoteLocally(noteModel.copyWith(isSynced: 1, isUpdated: 0));
          Log.info("${note.title} updated success");
        }
      } catch (e) {
        Log.error("${note.title} updated failed because ${e.toString()}");
      }
    }
  }
}
