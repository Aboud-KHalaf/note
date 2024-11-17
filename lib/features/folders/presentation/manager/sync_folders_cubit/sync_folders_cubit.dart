import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/features/folders/domain/use_casees/sync_folders_usecase.dart';

part 'sunc_folders_state.dart';

class SyncFoldersCubit extends Cubit<SyncFoldersState> {
  SyncFoldersCubit(this.syncFoldersUsecase) : super(SuncFoldersInitial());

  final SyncFoldersUsecase syncFoldersUsecase;
  Future<void> syncFolders() async {
    await syncFoldersUsecase.call();
  }
}
