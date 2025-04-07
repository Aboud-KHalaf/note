import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';
import 'package:note/features/notes/presentation/manager/fetch_all_notes_cubit/fetch_all_notes_cubit.dart';
import 'package:note/features/notes/presentation/views/home_view.dart';

class SyncingView extends StatefulWidget {
  static const String id = "syncing_view";
  const SyncingView({super.key});

  @override
  State<SyncingView> createState() => _SyncingViewState();
}

class _SyncingViewState extends State<SyncingView> {
  late final FetchAllNotesCubit _fetchAllNotesCubit;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchAllNotesCubit = context.read<FetchAllNotesCubit>();
    _checkInitialization();
  }

  Future<void> _checkInitialization() async {
    if (!_isInitialized) {
      await _fetchAllNotesCubit.fetchAllRemoteNotes();
      _isInitialized = true;
    }
  }

  void _handleSuccess() {
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(HomeView.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<FetchAllNotesCubit, FetchAllNotesState>(
        listener: (context, state) {
          if (state is FetchAllRemoteNotesSuccess) {
            _handleSuccess();
          }
        },
        builder: (context, state) {
          if (state is FetchAllNotesFaiure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      color: theme.colorScheme.error, size: 48),
                  SpacingHelper.h6,
                  Text(
                    state.errMessage,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  SpacingHelper.h6,
                  ElevatedButton(
                    onPressed: _checkInitialization,
                    child: Text('retry'.tr(context)),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  color: theme.primaryColor,
                ),
                SpacingHelper.h6,
                Text(
                  'syncing'.tr(context),
                  style: theme.textTheme.titleMedium,
                ),
                SpacingHelper.h6,
                Text(
                  'please_wait'.tr(context),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
