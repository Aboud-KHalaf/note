import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/domain/usecases/synce_notes_usecase.dart';

part 'sync_notes_state.dart';

class SynceNotesCubit extends Cubit<SyncNotesState> {
  SynceNotesCubit(this._synceNotesUsecase) : super(SyncNotesInitial());

  final SynceNotesUsecase _synceNotesUsecase;
  Future<void> synceNotes() async {
    var res = await _synceNotesUsecase.call();

    res.fold((failure) {
      emit(SyncNotesFailure(errMessage: failure.message));
    }, (unit) {
      emit(SyncNotesSuccess());
    });
  }
}
