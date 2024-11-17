import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/folders/domain/use_casees/create_folder_usecase.dart';
import 'package:note/features/folders/domain/use_casees/delete_folder_usecase.dart';
import 'package:note/features/folders/domain/use_casees/edit_folder_usecase.dart';
import 'package:note/features/folders/domain/use_casees/fetch_all_folders_usecase.dart';

import '../../../domain/entities/folder_entity.dart';

part 'folder_actions_state.dart';

class FolderActionsCubit extends Cubit<FolderActionsState> {
  FolderActionsCubit(
    this.createFolderUsecase,
    this.deleteFolderUsecase,
    this.editFolderUsecase,
    this.fetchAllFoldersUsecase,
  ) : super(FolderActionsInitial());

  final CreateFolderUsecase createFolderUsecase;
  final DeleteFolderUsecase deleteFolderUsecase;
  final EditFolderUsecase editFolderUsecase;
  final FetchAllFolderUsecase fetchAllFoldersUsecase;

  Future<void> createFolder({required FolderEntity folder}) async {
    emit(FolderActionsLoading());
    var res = await createFolderUsecase.call(folder);
    res.fold((failure) {
      emit(FolderActionsFailure(errMessage: failure.message));
    }, (unit) {
      emit(
        FolderActionsSuccess(),
      );
    });
  }

  Future<void> editFolder({required FolderEntity folder}) async {
    emit(FolderActionsLoading());
    var res = await editFolderUsecase.call(folder);
    res.fold(
        (failure) => emit(FolderActionsFailure(errMessage: failure.message)),
        (unit) => emit(FolderActionsSuccess()));
  }

  Future<void> deleteFolder({required FolderEntity folder}) async {
    emit(FolderActionsLoading());
    var res = await deleteFolderUsecase.call(folder);
    res.fold(
        (failure) => emit(FolderActionsFailure(errMessage: failure.message)),
        (unit) => emit(FolderActionsSuccess()));
  }

  Future<void> fetchAllFolders() async {
    emit(FolderActionsLoading());
    var res = await fetchAllFoldersUsecase.call();
    res.fold(
        (failure) => emit(FolderActionsFailure(errMessage: failure.message)),
        (folders) => emit(FetchFoldersNameSuccess(folders: folders)));
  }
}
