import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import 'package:note/core/error/failures.dart';
import 'package:note/core/helpers/providers/supabase_provider.dart';
import 'package:note/core/utils/logger.dart';
import 'package:note/features/notes/data/models/note_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';

abstract class NoteRemoteDataSource {
  Future<bool> uploadNote({required NoteModel note});
  Future<bool> updateNote({required NoteModel note});
  Future<String> uploadImage({required NoteModel note, required File image});
  Future<String> updateImage({required NoteModel note, required File newImage});
  Future<File> downloadImage({required NoteModel note});
  Future<void> deleteImage({required NoteModel note});
  Future<bool> deleteNote({required String noteId});
  Future<List<NoteModel>> fetchAllNotes();
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final SupabaseClient supabaseClient;

  NoteRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<bool> uploadNote({required NoteModel note}) async {
    try {
      await supabaseClient
          .from(SupabaseProvider.notesTable)
          .insert(note.toJson());
      return true;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<List<NoteModel>> fetchAllNotes() async {
    try {
      final userId = supabaseClient.auth.currentSession?.user.id;
      if (userId == null) {
        throw AuthApiException('User not authenticated');
      }

      final notes = await supabaseClient
          .from(SupabaseProvider.notesTable)
          .select()
          .eq('user_id', userId);

      Log.cyan("goooooood");
      return notes.map((note) => NoteModel.fromJson(note)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      if (e is AuthApiException) rethrow;
      throw const UnknownFailure();
    }
  }

  @override
  Future<bool> updateNote({required NoteModel note}) async {
    try {
      await supabaseClient
          .from(SupabaseProvider.notesTable)
          .update(note.toJson())
          .eq('id', note.id);
      return true;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<bool> deleteNote({required String noteId}) async {
    try {
      await supabaseClient
          .from(SupabaseProvider.notesTable)
          .delete()
          .eq('id', noteId);
      return true;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<String> uploadImage(
      {required NoteModel note, required File image}) async {
    try {
      final String path = note.id;
      await supabaseClient.storage
          .from(SupabaseProvider.noteImagesBucket)
          .upload(path, image);
      return supabaseClient.storage
          .from(SupabaseProvider.noteImagesBucket)
          .getPublicUrl(path);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<File> downloadImage({required NoteModel note}) async {
    final Dio dio = Dio();

    try {
      final String imagePath = note.id;
      final String imageUrl = supabaseClient.storage
          .from(SupabaseProvider.noteImagesBucket)
          .getPublicUrl(imagePath);

      // Set the directory and filename to save the image
      final Directory directory = await getApplicationDocumentsDirectory();
      final String fileExtension = path.extension(imageUrl);
      final String fileName = '${note.id}$fileExtension';
      final File file = File('${directory.path}/$fileName');

      // Check if the file already exists; if it does, return it directly
      if (await file.exists()) {
        return file;
      }

      // Download the image using Dio
      final Response<List<int>> response = await dio.get<List<int>>(
        imageUrl,
        options: Options(
          responseType: ResponseType.bytes,
        ),
      );

      // Check for successful download
      if (response.statusCode == 200) {
        // Write bytes to the file
        await file.writeAsBytes(response.data!);
        return file; // Return the saved file
      } else {
        throw ServerException(
            'Failed to download image: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      Log.cyan('Dio error: ${e.message}');
      throw ServerException('Failed to download image: ${e.message}');
    } on StorageException catch (e) {
      // Handle Supabase storage-related exceptions
      Log.cyan('Storage error: ${e.message}');
      throw ServerException(e.message);
    } on FileSystemException catch (e) {
      // Handle file-related exceptions
      Log.cyan('File system error: ${e.message}');
      throw ServerException('File system error: ${e.message}');
    } catch (e) {
      // Handle any other exceptions
      Log.cyan('Unknown error: ${e.toString()}');
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateImage({
    required NoteModel note,
    required File newImage,
  }) async {
    try {
      final String path = note.id;

      // First delete the existing image (if necessary)
      await supabaseClient.storage
          .from(SupabaseProvider.noteImagesBucket)
          .remove([path]);

      // Then upload the new image
      await supabaseClient.storage
          .from(SupabaseProvider.noteImagesBucket)
          .upload(path, newImage);

      // Return the public URL of the new image
      return supabaseClient.storage
          .from(SupabaseProvider.noteImagesBucket)
          .getPublicUrl(path);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<void> deleteImage({required NoteModel note}) async {
    try {
      final String path = note.imageUrl!;

      // Delete the image from storage
      await supabaseClient.storage
          .from(SupabaseProvider.noteImagesBucket)
          .remove([path]);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
