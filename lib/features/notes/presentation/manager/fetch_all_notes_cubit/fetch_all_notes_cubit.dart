import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/notes/domain/usecases/fetch_all_notes_usecase.dart';
import 'package:note/features/notes/domain/usecases/fetch_all_remote_notes_usecase.dart';

part 'fetch_all_notes_state.dart';

class FetchAllNotesCubit extends Cubit<FetchAllNotesState> {
  FetchAllNotesCubit(
      this._fetchAllNotesUsecase, this._fetchAllRemoteNotesUsecase)
      : super(FetchAllNotesInitial());

  final FetchAllNotesUsecase _fetchAllNotesUsecase;
  final FetchAllRemoteNotesUsecase _fetchAllRemoteNotesUsecase;
  Future<void> fetchAllNotes() async {
    emit(FetchAllNotesLoading());
    var res = await _fetchAllNotesUsecase.call();
    res.fold((failure) {
      emit(FetchAllNotesFaiure(errMessage: failure.message));
    }, (notes) {
      emit(FetchAllNotesSuccess(notes: notes));
    });
  }

  Future<void> fetchAllRemoteNotes() async {
    var res = await _fetchAllRemoteNotesUsecase.call();
    res.fold((failure) {
      emit(FetchAllNotesFaiure(errMessage: failure.message));
    }, (notes) {
      emit(FetchAllRemoteNotesSuccess());
    });
  }
}
