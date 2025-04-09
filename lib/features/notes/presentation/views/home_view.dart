import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/localization/app_localization.dart';

import 'package:note/features/notes/presentation/manager/synce_notes_cubit/sync_notes_cubit.dart';
import 'package:note/features/notes/presentation/widgets/home_drawer.dart';

import 'package:note/features/notes/presentation/widgets/home_view_body.dart';
import 'package:note/features/search/presentation/views/search_view.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircularProgressIndicator(
                          color: theme.hintColor,
                          strokeWidth: 2.0,
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SearchView.id);
                    },
                    icon: const Icon(
                      Icons.search,
                      size: 32,
                    ),
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
                tabs: [
                  Tab(text: 'all'.tr(context)),
                  Tab(text: 'folders'.tr(context)),
                ],
                labelColor: theme.hintColor,
                indicatorColor: theme.hintColor,
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
