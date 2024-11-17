import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
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
    try {
      // Sign out the user from Supabase
      await Supabase.instance.client.auth.signOut();
      print('User signed out successfully.');
    } catch (e) {
      // Handle any errors that occur during sign out
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const Drawer(),
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
