import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/notes/domain/entities/note_entity.dart';
import 'package:note/features/search/domain/use_cases/search_use_case.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.searchUseCase) : super(SearchInitial());

  final SearchUseCase searchUseCase;

  Future<void> search({required String text}) async {
    emit(SearchLoading());

    var res = await searchUseCase.call(text);
    res.fold(
      (failure) {
        emit(SearchFailure(mesage: failure.message));
      },
      (notes) {
        if (notes.isEmpty) {
          emit(SearchEmpty());
        } else {
          emit(
            SearchSuccess(notes: notes),
          );
        }
      },
    );
  }
}
