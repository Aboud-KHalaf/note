import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/domain/entities/required_data_entity.dart';
import 'package:note/features/notes/domain/usecases/insert_note_usecase.dart';

part 'upload_note_state.dart';

class UploadNoteCubit extends Cubit<UploadNoteState> {
  UploadNoteCubit(this._uploadNoteUsecase) : super(UploadNoteInitial());
  final InsertNoteUsecase _uploadNoteUsecase;

  Future<void> uploadNote({
    required RequiredDataEntity data,
  }) async {
    emit(UploadNoteLoading());
    var res = await _uploadNoteUsecase.call(
      data,
    );

    res.fold((failure) {
      emit(UploadNoteFailure(errmessage: failure.message));
    }, (note) {
      emit(UploadNoteSuccess());
    });
  }
}
