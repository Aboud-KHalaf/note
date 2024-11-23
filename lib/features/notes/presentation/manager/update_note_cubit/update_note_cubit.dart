import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/domain/entities/required_data_entity.dart';
import 'package:note/features/notes/domain/usecases/upadate_note_usecase.dart';

part 'update_note_state.dart';

class UpdateNoteCubit extends Cubit<UpdateNoteState> {
  UpdateNoteCubit(this._upadateNoteUsecase) : super(UpdateNoteInitial());

  final UpdateNoteUsecase _upadateNoteUsecase;
  Future<void> updateNote({required RequiredDataEntity data}) async {
    emit(UpdateNoteLoading());

    var res = await _upadateNoteUsecase.call(data);
    res.fold((failure) {
      emit(UpdateNoteFailure(errMessage: failure.message));
    }, (unit) {
      emit(UpdateNoteSuccess());
    });
  }
}
