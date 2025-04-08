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
                    ? theme.primaryColor.withOpacity(0.1)
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _showMarkdownGuide(context, isArabic: false),
                              icon: Icon(
                                Icons.language,
                                color: theme.hintColor,
                              ),
                              label: Text(
                                'English',
                                style: TextStyle(
                                  color: theme.hintColor,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.scaffoldBackgroundColor,
                                elevation: 0,
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
                              onPressed: () =>
                                  _showMarkdownGuide(context, isArabic: true),
                              icon: Icon(
                                Icons.language,
                                color: theme.hintColor,
                              ),
                              label: Text(
                                'العربية',
                                style: TextStyle(
                                  color: theme.hintColor,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.scaffoldBackgroundColor,
                                elevation: 0,
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
                        ),
                        // const SizedBox(height: 16),
                        //  _buildMarkdownGuideContent(isArabic: false),
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

  Widget _buildMarkdownSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).hintColor,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMarkdownGuideItem(
      String title, String syntax, String preview, String description) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          syntax,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: syntax));
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Copied to clipboard',
                                style: TextStyle(
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                              backgroundColor:
                                  theme.colorScheme.secondaryContainer,
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        }
                      },
                      icon: Icon(
                        Icons.content_copy,
                        color: theme.hintColor,
                        size: 20,
                      ),
                      tooltip: 'Copy syntax',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Preview:',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    preview,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMarkdownGuide(BuildContext context, {required bool isArabic}) {
    showDialog(
      context: context,
      builder: (context) => MarkdownGuide(
        isArabic: isArabic,
        theme: Theme.of(context),
      ),
    );
  }

  Widget _buildMarkdownGuideContent({required bool isArabic}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMarkdownSection(
          isArabic ? 'تنسيق النص' : 'Text Formatting',
          [
            _buildMarkdownGuideItem(
              isArabic ? 'عريض' : 'Bold',
              '**${isArabic ? 'نص عريض' : 'bold text'}**',
              isArabic ? 'نص عريض' : 'Bold text',
              isArabic ? 'جعل النص عريض' : 'Make text bold',
            ),
            _buildMarkdownGuideItem(
              isArabic ? 'مائل' : 'Italic',
              '*${isArabic ? 'نص مائل' : 'italic text'}*',
              isArabic ? 'نص مائل' : 'Italic text',
              isArabic ? 'جعل النص مائل' : 'Make text italic',
            ),
            _buildMarkdownGuideItem(
              isArabic ? 'عريض ومائل' : 'Bold & Italic',
              '***${isArabic ? 'نص عريض ومائل' : 'bold & italic'}***',
              isArabic ? 'نص عريض ومائل' : 'Bold & Italic',
              isArabic ? 'جعل النص عريض ومائل' : 'Make text bold and italic',
            ),
            _buildMarkdownGuideItem(
              isArabic ? 'يتوسطه خط' : 'Strikethrough',
              '~~${isArabic ? 'نص يتوسطه خط' : 'strikethrough'}~~',
              isArabic ? 'نص يتوسطه خط' : 'Strikethrough',
              isArabic ? 'إضافة خط في منتصف النص' : 'Add a line through text',
            ),
          ],
        ),
        _buildMarkdownSection(
          isArabic ? 'العناوين' : 'Headers',
          [
            _buildMarkdownGuideItem(
              'H1',
              '# ${isArabic ? 'عنوان 1' : 'Header 1'}',
              isArabic ? 'عنوان 1' : 'Header 1',
              isArabic ? 'عنوان رئيسي كبير' : 'Large main heading',
            ),
            _buildMarkdownGuideItem(
              'H2',
              '## ${isArabic ? 'عنوان 2' : 'Header 2'}',
              isArabic ? 'عنوان 2' : 'Header 2',
              isArabic ? 'عنوان فرعي متوسط' : 'Medium subheading',
            ),
            _buildMarkdownGuideItem(
              'H3',
              '### ${isArabic ? 'عنوان 3' : 'Header 3'}',
              isArabic ? 'عنوان 3' : 'Header 3',
              isArabic ? 'عنوان صغير' : 'Small heading',
            ),
          ],
        ),
        _buildMarkdownSection(
          isArabic ? 'القوائم' : 'Lists',
          [
            _buildMarkdownGuideItem(
              isArabic ? 'غير مرقمة' : 'Unordered',
              '- ${isArabic ? 'عنصر 1' : 'Item 1'}\n- ${isArabic ? 'عنصر 2' : 'Item 2'}\n- ${isArabic ? 'عنصر 3' : 'Item 3'}',
              isArabic
                  ? '• عنصر 1\n• عنصر 2\n• عنصر 3'
                  : '• Item 1\n• Item 2\n• Item 3',
              isArabic ? 'إنشاء قائمة غير مرقمة' : 'Create a bullet list',
            ),
            _buildMarkdownGuideItem(
              isArabic ? 'مرقمة' : 'Ordered',
              '1. ${isArabic ? 'أولاً' : 'First'}\n2. ${isArabic ? 'ثانياً' : 'Second'}\n3. ${isArabic ? 'ثالثاً' : 'Third'}',
              isArabic
                  ? '1. أولاً\n2. ثانياً\n3. ثالثاً'
                  : '1. First\n2. Second\n3. Third',
              isArabic ? 'إنشاء قائمة مرقمة' : 'Create a numbered list',
            ),
            _buildMarkdownGuideItem(
              isArabic ? 'قائمة المهام' : 'Task List',
              '- [ ] ${isArabic ? 'مهمة غير مكتملة' : 'Incomplete task'}\n- [x] ${isArabic ? 'مهمة مكتملة' : 'Completed task'}',
              isArabic
                  ? '☐ مهمة غير مكتملة\n☑ مهمة مكتملة'
                  : '☐ Incomplete task\n☑ Completed task',
              isArabic ? 'إنشاء قائمة مهام' : 'Create a task list',
            ),
          ],
        ),
        _buildMarkdownSection(
          isArabic ? 'الروابط والصور' : 'Links & Images',
          [
            _buildMarkdownGuideItem(
              isArabic ? 'رابط' : 'Link',
              '[${isArabic ? 'نص الرابط' : 'link text'}](${isArabic ? 'رابط' : 'url'})',
              isArabic ? 'نص الرابط' : 'link text',
              isArabic ? 'إضافة رابط' : 'Add a link',
            ),
            _buildMarkdownGuideItem(
              isArabic ? 'صورة' : 'Image',
              '![${isArabic ? 'وصف الصورة' : 'image alt'}](${isArabic ? 'رابط الصورة' : 'image url'})',
              isArabic ? 'صورة' : 'Image',
              isArabic ? 'إضافة صورة' : 'Add an image',
            ),
          ],
        ),
        _buildMarkdownSection(
          isArabic ? 'متقدم' : 'Advanced',
          [
            _buildMarkdownGuideItem(
              isArabic ? 'اقتباس' : 'Blockquote',
              '> ${isArabic ? 'نص الاقتباس' : 'Quote text'}',
              isArabic ? 'نص الاقتباس' : 'Quote text',
              isArabic ? 'إضافة اقتباس' : 'Add a quote',
            ),
            _buildMarkdownGuideItem(
              isArabic ? 'كود' : 'Code',
              '```\n${isArabic ? 'كود' : 'code'}\n```',
              isArabic ? 'كود' : 'code',
              isArabic ? 'إضافة كود' : 'Add code',
            ),
            _buildMarkdownGuideItem(
              isArabic ? 'جدول' : 'Table',
              '| ${isArabic ? 'العنوان' : 'Header'} | ${isArabic ? 'الوصف' : 'Description'} |\n|--------|-------------|\n| ${isArabic ? 'خلية' : 'Cell'}   | ${isArabic ? 'محتوى' : 'Content'}  |',
              isArabic ? 'جدول' : 'Table',
              isArabic ? 'إنشاء جدول' : 'Create a table',
            ),
          ],
        ),
      ],
    );
  }
}
