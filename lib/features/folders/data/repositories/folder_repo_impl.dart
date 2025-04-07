import 'package:dartz/dartz.dart';
import 'package:note/core/error/exceptions.dart';
import 'package:note/core/error/failures.dart';
import 'package:note/core/services/network_services.dart';
import 'package:note/core/utils/logger.dart';
import 'package:note/features/folders/data/data_soureces/folder_remote_data_source.dart';
import 'package:note/features/folders/data/models/folder_model.dart';
import 'package:note/features/folders/domain/entities/folder_entity.dart';
import 'package:note/features/folders/domain/repositories/folder_repo.dart';

import '../../../../core/services/shared_preferences_services.dart';
import '../data_soureces/folder_local_data_source.dart';

class FolderRepoImpl implements FolderRepository {
  final FolderLocalDataSource folderLocalDataSource;
  final FolderRemoteDataSource folderRemoteDataSource;
  final InternetConnectivity internetConnectivity;
  final SharedPreferencesService sharedPreferencesService;

  FolderRepoImpl(
      {required this.folderRemoteDataSource,
      required this.internetConnectivity,
      required this.sharedPreferencesService,
      required this.folderLocalDataSource});

  ResultFuture<Unit> _handleFolderOperation(
      Future<void> Function() folderOperation) async {
    try {
      await folderOperation();
      return right(unit);
    } on CacheException catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Unit> createFolder({required FolderEntity folder}) async {
    FolderModel folderModel = FolderModel(
        userID: await sharedPreferencesService.getUserId() ?? "",
        isDeleted: 0,
        isUpdated: 0,
        isSynced: 0,
        description: folder.description,
        id: folder.id,
        name: folder.name,
        color: folder.color);

    return _handleFolderOperation(
        () => folderLocalDataSource.createFolder(folder: folderModel));
  }

  @override
  ResultFuture<Unit> deleteFolder({required FolderEntity folder}) {
    final folderModel = FolderModel.fromEntity(folder);
    return _handleFolderOperation(() => folderLocalDataSource.updateFolder(
        folder: folderModel.copyWith(isDeleted: 1)));
  }

  @override
  ResultFuture<Unit> editFolder({required FolderEntity folder}) async {
    FolderModel folderModel = FolderModel.fromEntity(folder);
    folderModel = folderModel.copyWith(
        userID: await sharedPreferencesService.getUserId() ?? "");
    return _handleFolderOperation(
        () => folderLocalDataSource.updateFolder(folder: folderModel));
  }

  @override
  ResultFuture<List<FolderEntity>> fetchAllFolders() async {
    try {
      SharedPreferencesService sps = SharedPreferencesService();
      String id = await sps.getUserId() ?? "";
      List<FolderEntity> folders =
          await folderLocalDataSource.fetchAllFolders(userId: id);
      return right(folders);
    } on CacheException catch (e) {
      return left(CacheFailure(e.toString()));
    }
  }

  @override
  ResultFuture<Unit> synceFolders() async {
    bool isConnected = await internetConnectivity.isConnected();

    if (isConnected) {
      //
      await _syncDeletedFolders();
      await _syncUpdatedFolders();
      await _uploadUnSyncedNotes();
      //
      return right(unit);
    } else {
      Log.error("not connected");
      return left(const ServerFailure('No internet'));
    }
  }

  Future<void> _uploadUnSyncedNotes() async {
    Log.info("_uploadUnSyncedNotes start");
    final List<FolderModel> unsyncedFolders =
        await folderLocalDataSource.fetchLocalUnSyncedFolders();

    for (var folder in unsyncedFolders) {
      try {
        await folderRemoteDataSource.uploadFolder(
            folder: folder.toUploadFolderModel());
        await folderLocalDataSource.updateFolder(
            folder: folder.copyWith(isSynced: 1));
      } catch (e) {
        Log.error("${folder.name} upload failed because ${e.toString()}");
      }
    }
  }

  Future<void> _syncDeletedFolders() async {
    Log.info("_syncDeletedFolders start");
    final List<FolderModel> deletedFolders =
        await folderLocalDataSource.fetchLocalDeletedFolders();

    for (var folder in deletedFolders) {
      Log.error(folder.name);

      try {
        await folderRemoteDataSource.deleteFolder(
            folder: folder.toUploadFolderModel());

        await folderLocalDataSource.deleteFolder(folderId: folder.id);

        Log.info("${folder.name} deleted success");
      } catch (e) {
        Log.error("${folder.name} deleted failed because ${e.toString()}");
      }
    }
  }

  Future<void> _syncUpdatedFolders() async {
    Log.info("_syncUpdatedFolders start");
    final List<FolderModel> updatedFolders =
        await folderLocalDataSource.fetchLocalUpdatedFolders();

    for (var folder in updatedFolders) {
      Log.error(folder.name);

      try {
        await folderRemoteDataSource.updateFolder(
            folder: folder.toUploadFolderModel());

        await folderLocalDataSource.updateFolder(
            folder: folder.copyWith(isSynced: 1, isUpdated: 0));

        Log.info("${folder.name} deleted success");
      } catch (e) {
        Log.error("${folder.name} deleted failed because ${e.toString()}");
      }
    }
  }
}
