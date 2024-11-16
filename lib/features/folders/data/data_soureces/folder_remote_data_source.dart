import 'package:note/features/folders/data/models/folder_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';

abstract class FolderRemoteDataSource {
  Future<void> uploadFolder({required FolderModel folder});
  Future<void> deleteFolder({required FolderModel folder});
  Future<void> updateFolder({required FolderModel folder});
}

class FolderRemoteDataSourceImpl extends FolderRemoteDataSource {
  final SupabaseClient supabaseClient;

  FolderRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<void> uploadFolder({required FolderModel folder}) async {
    try {
      await supabaseClient.from('folders').insert(folder.toJson());
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<void> updateFolder({required FolderModel folder}) async {
    try {
      await supabaseClient
          .from('folders')
          .update(folder.toJson())
          .eq('id', folder.id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  @override
  Future<void> deleteFolder({required FolderModel folder}) async {
    try {
      await supabaseClient.from('folders').delete().eq('id', folder.id);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
