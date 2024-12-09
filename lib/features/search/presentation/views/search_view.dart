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

import '../../../notes/domain/entities/note_entity.dart';

class SearchView extends StatefulWidget {
  static const id = 'search';
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController searchContorller;
  @override
  void initState() {
    super.initState();
    searchContorller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomTextFormFieldWidget(
            hintText: 'search'.tr(context),
            controller: searchContorller,
            onChanged: (value) {
              if (value != "") {
                context.read<SearchCubit>().search(text: value);
              }
            },
            suffixIcon: const Icon(
              Icons.search,
            ),
          ),
        ),
        body: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchSuccess) {
              return SearchGridViewWidget(notes: state.notes);
            } else if (state is SearchEmpty) {
              return const SearchResultsEmpty();
            } else if (state is SearchFailure) {
              return Text(state.mesage);
            } else {
              return const InitialSearch();
            }
          },
        ));
  }
}

class InitialSearch extends StatelessWidget {
  const InitialSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: double.infinity,
      child: Center(
        child: Text(
          'search'.tr(context),
          textAlign: TextAlign.center,
          style: FontsStylesHelper.textStyle16,
        ),
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
      padding: const EdgeInsets.all(16),
      height: double.infinity,
      child: Center(
        child: Text(
          'no_search_notes'.tr(context),
          textAlign: TextAlign.center,
          style: FontsStylesHelper.textStyle16,
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
            ),
          );
        },
        staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
      ),
    );
  }
}
