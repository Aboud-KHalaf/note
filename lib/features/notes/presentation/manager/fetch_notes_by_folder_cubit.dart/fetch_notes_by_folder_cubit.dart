import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/domain/usecases/fetch_notes_by_folder_usecase.dart';

part 'fetch_notes_by_folder_state.dart';

class FetchNotesByFolderCubit extends Cubit<FetchNotesByFolderState> {
  FetchNotesByFolderCubit(this.fetchNotesByFolderUsecase)
      : super(FetchNotesByFolderInitial());

  final FetchNotesByFolderUsecase fetchNotesByFolderUsecase;

  Future<void> fetchNotesByFolder({required String folderName}) async {
    emit(FetchNotesByFolderLoading());
    var res = await fetchNotesByFolderUsecase.call(folderName);
    res.fold(
        (failure) => emit(FetchNotesByFolderFailure(message: failure.message)),
        (notes) => emit(FetchNotesByFolderSuccess(notes: notes)));
  }
}
