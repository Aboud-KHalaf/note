import 'package:note/core/error/exceptions.dart';
import 'package:note/core/services/database_services.dart';
import 'package:note/core/services/shared_preferences_services.dart';
import 'package:note/features/notes/data/models/note_model.dart';

abstract class SearchLocalDataSource {
  Future<List<NoteModel>> searchNotes({required String query});
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  final SharedPreferencesService sharedPreferencesService;

  SearchLocalDataSourceImpl({required this.sharedPreferencesService});

  @override
  Future<List<NoteModel>> searchNotes({required String query}) async {
    String? userId = await sharedPreferencesService.getUserId();
    if (userId == null) {
      throw const ServerException('user not logged in');
    }
    List<Map<String, dynamic>> notesJson =
        await SQLiteService.instance.searchNotes(query: query, userId: userId);

    return notesJson
        .map(
          (e) => NoteModel.fromJson(e),
        )
        .toList();
  }
}
