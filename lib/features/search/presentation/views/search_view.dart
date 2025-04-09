import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';
import 'package:note/core/widgets/custom_text_form_field_w.dart';
import 'package:note/features/notes/presentation/views/note_detail_view.dart';
import 'package:note/features/notes/presentation/widgets/note_card.dart';
import 'package:note/features/search/presentation/manager/search_cubit/search_cubit.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../notes/domain/entities/note_entity.dart';

class SearchView extends StatefulWidget {
  static const id = 'search';
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController searchContorller;
  late SearchCubit searchCubit;

  @override
  void initState() {
    super.initState();
    searchContorller = TextEditingController();
    searchCubit = context.read<SearchCubit>();
    // Reset search state when view is initialized
    searchCubit.emit(SearchInitial());
  }

  @override
  void dispose() {
    searchContorller.dispose();
    super.dispose();
  }

  void _clearSearch() {
    searchContorller.clear();
    searchCubit.emit(SearchInitial());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: CustomTextFormFieldWidget(
          hintText: 'search'.tr(context),
          controller: searchContorller,
          onChanged: (value) {
            if (value.isEmpty) {
              // Reset state when search is cleared
              searchCubit.emit(SearchInitial());
            } else {
              searchCubit.search(text: value);
            }
          },
          suffixIcon: Icon(
            Icons.search,
            color: Theme.of(context).hintColor,
          ),
        ),
        actions: [
          if (searchContorller.text.isNotEmpty)
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).hintColor,
              ),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchSuccess) {
            return SearchGridViewWidget(notes: state.notes);
          } else if (state is SearchEmpty) {
            return const SearchResultsEmpty();
          } else if (state is SearchFailure) {
            return Center(
              child: Text(
                state.mesage,
                style: FontsStylesHelper.textStyle16.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            );
          } else {
            return const InitialSearch();
          }
        },
      ),
    );
  }
}

class InitialSearch extends StatelessWidget {
  const InitialSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Theme.of(context).hintColor.withOpacity(0.5),
          )
              .animate()
              .fade(duration: const Duration(milliseconds: 500))
              .scale(delay: const Duration(milliseconds: 200)),
          const SizedBox(height: 24),
          const SizedBox(width: double.infinity),
          Text(
            'search'.tr(context),
            textAlign: TextAlign.center,
            style: FontsStylesHelper.textStyle16.copyWith(
              color: Theme.of(context).hintColor.withOpacity(0.7),
            ),
          )
              .animate()
              .fade(delay: const Duration(milliseconds: 300))
              .slideY(begin: 0.3, end: 0),
        ],
      ),
    );
  }
}

class SearchResultsEmpty extends StatelessWidget {
  const SearchResultsEmpty({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: double.infinity,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).hintColor.withOpacity(0.5),
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 500))
                .scale(delay: const Duration(milliseconds: 200)),
            const SizedBox(height: 24),
            Text(
              'no_search_notes'.tr(context),
              textAlign: TextAlign.center,
              style: FontsStylesHelper.textStyle16.copyWith(
                color: Theme.of(context).hintColor.withOpacity(0.7),
              ),
            )
                .animate()
                .fade(delay: const Duration(milliseconds: 300))
                .slideY(begin: 0.3, end: 0),
          ],
        ),
      ),
    );
  }
}

class SearchGridViewWidget extends StatelessWidget {
  const SearchGridViewWidget({
    super.key,
    required this.notes,
  });

  final List<NoteEntity> notes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NoteDetailScreen(
                    note: notes[index],
                  ),
                ),
              );
            },
            child: NoteCard(
              note: notes[index],
              cardColor: AppColors.cardColors[notes[index].color],
              isSelected: false,
            )
                .animate()
                .fade(duration: const Duration(milliseconds: 300))
                .scale(delay: Duration(milliseconds: index * 50)),
          );
        },
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
    );
  }
}
