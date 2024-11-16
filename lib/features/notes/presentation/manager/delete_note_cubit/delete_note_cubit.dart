import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/data/models/note_model.dart';
import 'package:note/features/notes/domain/usecases/delete_note_usecase.dart';

import '../../../domain/entities/note_entity.dart';

part 'delete_note_state.dart';

class DeleteNoteCubit extends Cubit<DeleteNoteState> {
  DeleteNoteCubit(this.deleteNoteUsecase) : super(DeleteNoteInitial());
  final DeleteNoteUsecase deleteNoteUsecase;

  Future<void> deleteNote({required NoteEntity note}) async {
    emit(DeleteNoteLoading());
    var res = await deleteNoteUsecase.call(note: note as NoteModel);
    res.fold((falure) {
      emit(DeleteNoteFailure(errMessage: falure.message));
    }, (unit) {
      emit(DeleteNoteSuccess());
    });
  }
}
