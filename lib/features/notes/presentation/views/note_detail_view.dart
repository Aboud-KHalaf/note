import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../domain/entities/note_entity.dart';
import '../logic/note_detail_screen_logic.dart';
import '../widgets/fab_menu.dart';
import '../widgets/image_display.dart';
import '../widgets/title_and_content_text_fields.dart';

class NoteDetailScreen extends StatefulWidget {
  static String id = 'note-detail';
  final NoteEntity? note;
  final String? folder;

  const NoteDetailScreen({super.key, this.note, this.folder});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late NoteDetailScreenLogic _logic;

  @override
  void initState() {
    super.initState();
    _logic = NoteDetailScreenLogic(
      context: context,
      note: widget.note,
      folder: widget.folder,
      onStateUpdate: () => setState(() {}),
    );
  }

  @override
  void dispose() {
    _logic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: _logic.getNoteBackgroundColor(theme),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _logic.getNoteBackgroundColor(Theme.of(context)),
        title: _logic.buildAppBarTitle(context),
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return SizedBox(
      child: Stack(
        children: <Widget>[
          WillPopScope(
            onWillPop: _logic.handleBackNavigation,
            child: _buildNoteContent(),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FabMenu(
              onColorPressed: _logic.showColorSelectionSheet,
              onFolderPressed: _logic.showFolderSelectionSheet,
              onImagePressed: _logic.showImageSourceDialog,
            )
                .animate()
                .scale(duration: const Duration(milliseconds: 300))
                .fade(duration: const Duration(milliseconds: 300)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteContent() {
    return CustomScrollView(
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (_logic.selectedImage != null) _buildImageDisplay(),
              TitleField(
                controller: _logic.titleController,
                direction: _logic.titleTextDirection,
                onChanged: _logic.detectTitleTextDirection,
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 300))
                  .slideX(begin: 0.1, end: 0),
              const SizedBox(height: 16),
              ContentField(
                controller: _logic.contentController,
                direction: _logic.contentTextDirection,
                onChanged: _logic.detectContentTextDirection,
              )
                  .animate()
                  .fade(duration: const Duration(milliseconds: 300))
                  .slideX(
                      begin: 0.1,
                      end: 0,
                      delay: const Duration(milliseconds: 100)),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildImageDisplay() {
    return GestureDetector(
      onTap: _logic.openFullImageView,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: ImageDisplay(
          image: _logic.selectedImage!,
          onLongPress: _logic.showImageOptions,
        ),
      ),
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 300))
        .scale(delay: const Duration(milliseconds: 50));
  }
}
