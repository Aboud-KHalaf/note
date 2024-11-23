import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/services/shared_preferences_services.dart';
import 'package:note/core/utils/logger.dart';
import 'package:note/features/auth/presentation/manager/get_user_cubit/get_user_cubit.dart';
import 'package:note/features/folders/data/data_soureces/folder_local_data_source.dart';
import 'package:note/features/folders/data/data_soureces/folder_remote_data_source.dart';
import 'package:note/features/folders/data/models/folder_model.dart';
import 'package:note/features/notes/presentation/manager/synce_notes_cubit/sync_notes_cubit.dart';

import 'package:note/features/notes/presentation/widgets/home_view_body.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../folders/presentation/manager/folder_actions_cubit/folder_actions_cubit.dart';
import '../manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';

class HomeView extends StatefulWidget {
  static String id = "home_id";

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();

    final fetchAllNotesCubit = BlocProvider.of<FetchAllNotesCubit>(context);
    final folderActionsCubit = BlocProvider.of<FolderActionsCubit>(context);

    // Trigger fetching of notes and folders
    fetchAllNotesCubit.fetchAllNotes();
    folderActionsCubit.fetchAllFolders();
    // Listen to the state of FetchAllNotesCubit to wait for it to complete
  }

  Future<void> signOutUser() async {
    FolderLocalDataSource folderLocalDataSource = FolderLocalDataSourceImple();
    FolderRemoteDataSource folderRemoteDataSource =
        FolderRemoteDataSourceImpl(supabaseClient: Supabase.instance.client);

    Log.info("connected ... upload folders start");
    final List<FolderModel> unsyncedFolders =
        await folderLocalDataSource.fetchLocalUnSyncedFolders();

    for (var folder in unsyncedFolders) {
      try {
        Log.cyan(folder.name);
        await folderRemoteDataSource.uploadFolder(
            folder: folder.toUploadFolderModel());
        await folderLocalDataSource.updateFolder(
            folder: folder.copyWith(isSynced: 1));
      } catch (e) {
        Log.error("${folder.name} upload failed because ${e.toString()}");
      }
    }

    // try {
    //   // Sign out the user from Supabase
    //   await Supabase.instance.client.auth.signOut();
    //   print('User signed out successfully.');
    // } catch (e) {
    //   // Handle any errors that occur during sign out
    //   print('Error signing out: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const HomeDrawer(),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              elevation: 0,
              title: Text(
                "notes".tr(context),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                BlocBuilder<SynceNotesCubit, SyncNotesState>(
                  builder: (context, state) {
                    if (state is SyncNotesLoading) {
                      return const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          color: AppColors.secondary,
                          strokeWidth: 2.0,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                IconButton(
                  onPressed: signOutUser,
                  icon: const Icon(
                    Icons.search,
                    size: 32,
                  ),
                )
              ],
              floating: true, // AppBar floats when scrolling
              snap: true, // AppBar snaps into view when scrolling down
              expandedHeight: 120.0, // Height of the AppBar when fully expanded
              flexibleSpace: const FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
              ),
              pinned: true, // Keeps the TabBar pinned
              bottom: TabBar(
                unselectedLabelColor: AppColors.primary,
                tabs: [
                  Tab(text: 'all'.tr(context)),
                  Tab(text: 'folders'.tr(context)),
                ],
                labelColor: AppColors.secondary,
                indicatorColor: AppColors.secondary,
                indicatorWeight: 3.0,
                automaticIndicatorColorAdjustment: false,
                dividerColor: Colors.transparent,
              ),
            ),
          ],
          body: const HomeViewBody(),
        ),
      ),
    );
  }
}

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.all(16),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi, name!', // Personal greeting
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Welcome back!', // Optional subtitle
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Theme",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            SwitchListTile(
              title: const Text('Dark Mode'),
              value: true, // Replace with your theme logic
              onChanged: (isDark) {},
              inactiveThumbColor: AppColors.secondary,
              activeColor: AppColors.secondary,
            ),

            // Language Selector
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Language",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Set language to Arabic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardColor,
                      foregroundColor: AppColors.secondary,
                    ),
                    child: const Text("العربية"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Set language to English
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cardColor,
                      foregroundColor: AppColors.secondary,
                    ),
                    child: const Text("English"),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Footer (Optional)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "App Version: 1.0.0",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.secondary.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
