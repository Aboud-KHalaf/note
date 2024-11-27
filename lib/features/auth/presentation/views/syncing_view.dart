import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';
import 'package:note/features/auth/presentation/manager/get_user_cubit/get_user_cubit.dart';
import 'package:note/features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import 'package:note/features/notes/presentation/views/home_view.dart';

class SyncingView extends StatefulWidget {
  static const String id = "syncing_view";
  const SyncingView({super.key});

  @override
  State<SyncingView> createState() => _SyncingViewState();
}

class _SyncingViewState extends State<SyncingView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GetUserCubit>(context).getUserData();
    BlocProvider.of<FetchAllNotesCubit>(context).fetchAllRemoteNotes();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: BlocBuilder<FetchAllNotesCubit, FetchAllNotesState>(
        builder: (context, state) {
          if (state is FetchAllNotesFaiure) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.errMessage),
              ],
            );
          } else if (state is FetchAllRemoteNotesSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pushReplacementNamed(HomeView.id);
            });
            return const SizedBox();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SpacingHelper.widthExtender,
                CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
                SpacingHelper.h6,
                SpacingHelper.h6,
                Text('syncing'.tr(context)),
              ],
            );
          }
        },
      ),
    );
  }
}
