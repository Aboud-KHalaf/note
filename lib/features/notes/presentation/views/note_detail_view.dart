import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:note/features/notes/presentation/widgets/markdown_content.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/note_entity.dart';
import '../logic/note_detail_screen_logic.dart';
import '../widgets/fab_menu.dart';
import '../widgets/image_display.dart';
import '../widgets/title_and_content_text_fields.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../widgets/markdown_guide.dart';

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
  bool _isEditing = true;

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
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _isEditing
                    ? theme.primaryColor.withOpacity(0.3)
                    : theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _isEditing ? Icons.visibility : Icons.edit,
                color: _isEditing
                    ? theme.primaryColor
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.help_outline,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Row(
                    children: [
                      Icon(
                        Icons.code,
                        color: theme.primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Markdown Guide',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isSmallScreen = constraints.maxWidth < 400;
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _showMarkdownGuide(context,
                                      isArabic: false),
                                  icon: Icon(
                                    Icons.language,
                                    color: theme.hintColor,
                                    size: isSmallScreen ? 16 : 20,
                                  ),
                                  label: Text(
                                    'English',
                                    style: TextStyle(
                                      color: theme.hintColor,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        theme.scaffoldBackgroundColor,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 12 : 16,
                                      vertical: isSmallScreen ? 8 : 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: theme.hintColor.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _showMarkdownGuide(context,
                                      isArabic: true),
                                  icon: Icon(
                                    Icons.language,
                                    color: theme.hintColor,
                                    size: isSmallScreen ? 16 : 20,
                                  ),
                                  label: Text(
                                    'العربية',
                                    style: TextStyle(
                                      color: theme.hintColor,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        theme.scaffoldBackgroundColor,
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 12 : 16,
                                      vertical: isSmallScreen ? 8 : 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: theme.hintColor.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Stack(
      children: <Widget>[
        PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (!didPop) {
              final currentContext = context;
              Log.info("Saving note before navigation");
              await _logic.handleBackNavigation();
              if (currentContext.mounted) {
                Navigator.of(currentContext).pop();
              }
            }
          },
          child: _buildNoteContent(),
        ),
        Positioned(
          right: 24,
          bottom: 24,
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
    );
  }

  Widget _buildNoteContent() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
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
              _isEditing
                  ? ContentField(
                      controller: _logic.contentController,
                      direction: _logic.contentTextDirection,
                      onChanged: _logic.detectContentTextDirection,
                    )
                      .animate()
                      .fade(duration: const Duration(milliseconds: 300))
                      .slideX(
                          begin: 0.1,
                          end: 0,
                          delay: const Duration(milliseconds: 100))
                  : MarkdownContent(
                      content: _logic.contentController.text,
                      direction: _logic.contentTextDirection,
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: _logic.openFullImageView,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ImageDisplay(
            image: _logic.selectedImage!,
            onLongPress: _logic.showImageOptions,
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: const Duration(milliseconds: 300))
        .scale(delay: const Duration(milliseconds: 50));
  }

  void _showMarkdownGuide(BuildContext context, {required bool isArabic}) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 32,
          vertical: 24,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? size.width : 600,
            maxHeight: size.height * 0.8,
          ),
          child: MarkdownGuide(
            isArabic: isArabic,
            theme: Theme.of(context),
          ),
        ),
      ),
    );
  }
}
