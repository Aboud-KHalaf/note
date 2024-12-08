import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/cubits/theme_cubit/theme_cubit.dart';
import 'package:note/features/search/presentation/manager/search_cubit/search_cubit.dart';
import '../../cubits/localizations_cubit/localizations_cubit.dart';
import '../../../features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import '../../../features/folders/presentation/manager/sync_folders_cubit/sync_folders_cubit.dart';
import '../../../features/notes/presentation/manager/synce_notes_cubit/sync_notes_cubit.dart';

import '../../../features/auth/presentation/manager/get_user_cubit/get_user_cubit.dart';
import '../../../features/folders/presentation/manager/folder_actions_cubit/folder_actions_cubit.dart';
import '../../../features/notes/presentation/manager/delete_note_cubit/delete_note_cubit.dart';
import '../../../features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import '../../../features/notes/presentation/manager/fetch_notes_by_folder_cubit.dart/fetch_notes_by_folder_cubit.dart';
import '../../../features/notes/presentation/manager/update_note_cubit/update_note_cubit.dart';
import '../../../features/notes/presentation/manager/upload_note_cubit/upload_note_cubit.dart';
import '../../services/services_locator_imports.dart';

List<BlocProvider> providers = [
  BlocProvider<LocalizationsCubit>(
    create: (BuildContext context) => sl<LocalizationsCubit>(),
  ),
  BlocProvider<SearchCubit>(
    create: (BuildContext context) => sl<SearchCubit>(),
  ),
  BlocProvider<SynceNotesCubit>(
    create: (BuildContext context) => sl<SynceNotesCubit>(),
  ),
  BlocProvider<AuthCubit>(
    create: (BuildContext context) => sl<AuthCubit>(),
  ),
  BlocProvider<UploadNoteCubit>(
    create: (BuildContext context) => sl<UploadNoteCubit>(),
  ),
  BlocProvider<GetUserCubit>(
    create: (BuildContext context) => sl<GetUserCubit>(),
  ),
  BlocProvider<FetchAllNotesCubit>(
    create: (BuildContext context) => sl<FetchAllNotesCubit>(),
  ),
  BlocProvider<DeleteNoteCubit>(
    create: (BuildContext context) => sl<DeleteNoteCubit>(),
  ),
  BlocProvider<UpdateNoteCubit>(
    create: (BuildContext context) => sl<UpdateNoteCubit>(),
  ),
  BlocProvider<FolderActionsCubit>(
    create: (BuildContext context) => sl<FolderActionsCubit>(),
  ),
  BlocProvider<FetchNotesByFolderCubit>(
    create: (BuildContext context) => sl<FetchNotesByFolderCubit>(),
  ),
  BlocProvider<SyncFoldersCubit>(
    create: (BuildContext context) => sl<SyncFoldersCubit>(),
  ),
  BlocProvider<ThemeCubit>(create: (BuildContext context) => sl<ThemeCubit>()),
];
