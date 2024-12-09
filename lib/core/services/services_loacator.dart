part of 'services_locator_imports.dart';

final sl = GetIt.instance; //  a global service locator instance

Future<void> initApp() async {
  // Set the BlocObserver
  Bloc.observer = SimpleBlocObserver();
  // Initialize Supabase
  final supabase = await Supabase.initialize(
    url: SupabaseSecrets.supabaseUrl,
    anonKey: SupabaseSecrets.supabaseAnonKey,
    // remove
    debug: true,
  );
  // Register Supabase Client
  sl.registerLazySingleton<SupabaseClient>(() => supabase.client);
  sl.registerLazySingleton<SharedPreferencesService>(
      () => SharedPreferencesService());

  sl.registerLazySingleton<InternetConnectivity>(
      () => InternetConnectivityImpl());

  sl.registerFactory<LocalizationsCubit>(
    () => LocalizationsCubit(sl()),
  );
  sl.registerFactory<ThemeCubit>(
    () => ThemeCubit(sl()),
  );
  _initAuth();
  _initNote();
  _initFolder();
  _initSearch();
}

Future<void> _initSearch() async {
  // Register Local Data Sources
  sl.registerLazySingleton<SearchLocalDataSourceImpl>(
      () => SearchLocalDataSourceImpl(sharedPreferencesService: sl()));

  // Register Search Repositories
  sl.registerLazySingleton<SearchRepoImpl>(
    () => SearchRepoImpl(
      searchLocalDataSourceImpl: sl<SearchLocalDataSourceImpl>(),
    ),
  );

  // Register UseCases
  sl.registerLazySingleton<SearchUseCase>(
    () => SearchUseCase(searchRepository: sl<SearchRepoImpl>()),
  );

  // Register Cubits
  sl.registerFactory<SearchCubit>(
    () => SearchCubit(sl<SearchUseCase>()),
  );
}

Future<void> _initAuth() async {
  // Register Remote Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
  // Register Local Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferencesService: sl()),
  );

  // Register Auth Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authRemoteDataSource: sl(),
      authLocalDataSource: sl(),
    ),
  );

  // Register UseCases
  sl.registerLazySingleton<SignUpWithEmailAndPasswordUsecase>(
    () => SignUpWithEmailAndPasswordUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<SignInWithEmailAndPasswordUsecase>(
    () => SignInWithEmailAndPasswordUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<GetUserDataUsecase>(
    () => GetUserDataUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<IsUserLoggedInUseCase>(
    () => IsUserLoggedInUseCase(authRepository: sl()),
  );
  sl.registerLazySingleton<GoogleSignInUsecase>(
    () => GoogleSignInUsecase(authRepository: sl()),
  );
  sl.registerLazySingleton<SignOutUsecase>(
    () => SignOutUsecase(authRepository: sl()),
  );

  // Register Cubits
  sl.registerFactory<AuthCubit>(
    () => AuthCubit(sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<GetUserCubit>(
    () => GetUserCubit(sl(), sl()),
  );
}

Future<void> _initNote() async {
  // Register Remote Data Sources
  sl.registerLazySingleton<NoteRemoteDataSource>(
    () => NoteRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // Register Local Data Sources
  sl.registerLazySingleton<NoteLocalDataSource>(
      () => NoteLocalDataSourceImpl());

  // Register Note Repositories
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(
      noteRemoteDataSource: sl(),
      noteLocalDataSource: sl(),
      internetConnectivity: sl(),
    ),
  );

  // Register UseCases
  sl.registerLazySingleton<InsertNoteUsecase>(
    () => InsertNoteUsecase(noteRepository: sl()),
  );
  sl.registerLazySingleton<FetchAllNotesUsecase>(
    () => FetchAllNotesUsecase(noteRepository: sl()),
  );
  sl.registerLazySingleton<DeleteNoteUsecase>(
    () => DeleteNoteUsecase(noteRepository: sl()),
  );
  sl.registerLazySingleton<UpdateNoteUsecase>(
    () => UpdateNoteUsecase(noteRepository: sl()),
  );
  sl.registerLazySingleton<FetchNotesByFolderUsecase>(
    () => FetchNotesByFolderUsecase(noteRepository: sl()),
  );
  sl.registerLazySingleton<SynceNotesUsecase>(
    () => SynceNotesUsecase(noteRepository: sl()),
  );
  sl.registerLazySingleton<FetchAllRemoteNotesUsecase>(
    () => FetchAllRemoteNotesUsecase(noteRepository: sl()),
  );

  // Register Cubits
  sl.registerFactory<UploadNoteCubit>(
    () => UploadNoteCubit(sl()),
  );
  sl.registerFactory<FetchAllNotesCubit>(
    () => FetchAllNotesCubit(sl(), sl()),
  );
  sl.registerFactory<DeleteNoteCubit>(
    () => DeleteNoteCubit(sl()),
  );
  sl.registerFactory<UpdateNoteCubit>(
    () => UpdateNoteCubit(sl()),
  );
  sl.registerFactory<FetchNotesByFolderCubit>(
    () => FetchNotesByFolderCubit(sl()),
  );
  sl.registerFactory<SynceNotesCubit>(
    () => SynceNotesCubit(sl()),
  );
}

Future<void> _initFolder() async {
  // Register Remote Data Sources

  // Register Local Data Sources
  sl.registerLazySingleton<FolderLocalDataSource>(
      () => FolderLocalDataSourceImple());
  // Register remote Data Sources
  sl.registerLazySingleton<FolderRemoteDataSource>(
      () => FolderRemoteDataSourceImpl(supabaseClient: sl()));

  // Register Note Repositories
  sl.registerLazySingleton<FolderRepository>(
    () => FolderRepoImpl(
      folderLocalDataSource: sl(),
      folderRemoteDataSource: sl(),
      sharedPreferencesService: sl(),
      internetConnectivity: sl(),
    ),
  );

  // Register UseCases
  sl.registerLazySingleton<CreateFolderUsecase>(
    () => CreateFolderUsecase(folderRepository: sl()),
  );
  sl.registerLazySingleton<DeleteFolderUsecase>(
    () => DeleteFolderUsecase(folderRepository: sl()),
  );
  sl.registerLazySingleton<EditFolderUsecase>(
    () => EditFolderUsecase(folderRepository: sl()),
  );

  sl.registerLazySingleton<FetchAllFolderUsecase>(
    () => FetchAllFolderUsecase(folderRepository: sl()),
  );

  sl.registerLazySingleton<SyncFoldersUsecase>(
    () => SyncFoldersUsecase(folderRepository: sl()),
  );

  // Register Cubits
  sl.registerFactory<FolderActionsCubit>(
    () => FolderActionsCubit(sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<SyncFoldersCubit>(
    () => SyncFoldersCubit(sl()),
  );
}
