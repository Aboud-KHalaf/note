import 'package:flutter/material.dart';
import 'markdown_guide_item.dart';
import 'markdown_content.dart';

class MarkdownGuide extends StatelessWidget {
  final bool isArabic;
  final ThemeData theme;

  const MarkdownGuide({
    super.key,
    required this.isArabic,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: AlertDialog(
        title: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.code,
                color: theme.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                isArabic ? 'دليل ماركداون' : 'Markdown Guide',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        content: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMarkdownSection(
                  isArabic ? 'الأساسيات' : 'Basics',
                  [
                    MarkdownGuideItem(
                      title: isArabic ? 'عريض' : 'Bold',
                      syntax: '**${isArabic ? 'نص عريض' : 'bold text'}**',
                      preview: isArabic ? 'نص عريض' : 'Bold text',
                      description:
                          isArabic ? 'جعل النص عريض' : 'Make text bold',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: isArabic ? 'مائل' : 'Italic',
                      syntax: '*${isArabic ? 'نص مائل' : 'italic text'}*',
                      preview: isArabic ? 'نص مائل' : 'Italic text',
                      description:
                          isArabic ? 'جعل النص مائل' : 'Make text italic',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: isArabic ? 'عريض ومائل' : 'Bold & Italic',
                      syntax:
                          '***${isArabic ? 'نص عريض ومائل' : 'bold & italic'}***',
                      preview: isArabic ? 'نص عريض ومائل' : 'Bold & Italic',
                      description: isArabic
                          ? 'جعل النص عريض ومائل'
                          : 'Make text bold and italic',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: isArabic ? 'يتوسطه خط' : 'Strikethrough',
                      syntax:
                          '~~${isArabic ? 'نص يتوسطه خط' : 'strikethrough'}~~',
                      preview: isArabic ? 'نص يتوسطه خط' : 'Strikethrough',
                      description: isArabic
                          ? 'إضافة خط في منتصف النص'
                          : 'Add a line through text',
                      theme: theme,
                    ),
                  ],
                ),
                _buildMarkdownSection(
                  isArabic ? 'العناوين' : 'Headers',
                  [
                    MarkdownGuideItem(
                      title: 'H1',
                      syntax: '# ${isArabic ? 'عنوان رئيسي' : 'Main Title'}',
                      preview: isArabic ? 'عنوان رئيسي' : 'Main Title',
                      description:
                          isArabic ? 'عنوان رئيسي كبير' : 'Large main heading',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: 'H2',
                      syntax: '## ${isArabic ? 'عنوان فرعي' : 'Subtitle'}',
                      preview: isArabic ? 'عنوان فرعي' : 'Subtitle',
                      description:
                          isArabic ? 'عنوان فرعي متوسط' : 'Medium subheading',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: 'H3',
                      syntax: '### ${isArabic ? 'عنوان صغير' : 'Small Title'}',
                      preview: isArabic ? 'عنوان صغير' : 'Small Title',
                      description: isArabic ? 'عنوان صغير' : 'Small heading',
                      theme: theme,
                    ),
                  ],
                ),
                _buildMarkdownSection(
                  isArabic ? 'القوائم' : 'Lists',
                  [
                    MarkdownGuideItem(
                      title: isArabic ? 'قائمة غير مرقمة' : 'Bullet List',
                      syntax:
                          '- ${isArabic ? 'عنصر 1' : 'Item 1'}\n- ${isArabic ? 'عنصر 2' : 'Item 2'}\n- ${isArabic ? 'عنصر 3' : 'Item 3'}',
                      preview: isArabic
                          ? '• عنصر 1\n• عنصر 2\n• عنصر 3'
                          : '• Item 1\n• Item 2\n• Item 3',
                      description: isArabic
                          ? 'إنشاء قائمة غير مرقمة'
                          : 'Create a bullet list',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: isArabic ? 'قائمة مرقمة' : 'Numbered List',
                      syntax:
                          '1. ${isArabic ? 'أولاً' : 'First'}\n2. ${isArabic ? 'ثانياً' : 'Second'}\n3. ${isArabic ? 'ثالثاً' : 'Third'}',
                      preview: isArabic
                          ? '1. أولاً\n2. ثانياً\n3. ثالثاً'
                          : '1. First\n2. Second\n3. Third',
                      description: isArabic
                          ? 'إنشاء قائمة مرقمة'
                          : 'Create a numbered list',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: isArabic ? 'قائمة المهام' : 'Task List',
                      syntax:
                          '- [ ] ${isArabic ? 'مهمة غير مكتملة' : 'Incomplete task'}\n- [x] ${isArabic ? 'مهمة مكتملة' : 'Completed task'}',
                      preview: isArabic
                          ? '☐ مهمة غير مكتملة\n☑ مهمة مكتملة'
                          : '☐ Incomplete task\n☑ Completed task',
                      description:
                          isArabic ? 'إنشاء قائمة مهام' : 'Create a task list',
                      theme: theme,
                    ),
                  ],
                ),
                _buildMarkdownSection(
                  isArabic ? 'الروابط والصور' : 'Links & Images',
                  [
                    MarkdownGuideItem(
                      title: isArabic ? 'رابط' : 'Link',
                      syntax:
                          '[${isArabic ? 'نص الرابط' : 'link text'}](${isArabic ? 'رابط' : 'url'})',
                      preview: isArabic ? 'نص الرابط' : 'link text',
                      description: isArabic ? 'إضافة رابط' : 'Add a link',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: isArabic ? 'صورة' : 'Image',
                      syntax:
                          '![${isArabic ? 'وصف الصورة' : 'image alt'}](${isArabic ? 'رابط الصورة' : 'image url'})',
                      preview: isArabic ? 'صورة' : 'Image',
                      description: isArabic ? 'إضافة صورة' : 'Add an image',
                      theme: theme,
                    ),
                  ],
                ),
                _buildMarkdownSection(
                  isArabic ? 'التنسيق المتقدم' : 'Advanced Formatting',
                  [
                    MarkdownGuideItem(
                      title: isArabic ? 'اقتباس' : 'Quote',
                      syntax: '> ${isArabic ? 'نص الاقتباس' : 'Quote text'}',
                      preview: isArabic ? 'نص الاقتباس' : 'Quote text',
                      description: isArabic ? 'إضافة اقتباس' : 'Add a quote',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: isArabic ? 'كود' : 'Code',
                      syntax: '```\n${isArabic ? 'كود' : 'code'}\n```',
                      preview: isArabic ? 'كود' : 'code',
                      description: isArabic ? 'إضافة كود' : 'Add code',
                      theme: theme,
                    ),
                    MarkdownGuideItem(
                      title: isArabic ? 'جدول' : 'Table',
                      syntax:
                          '| ${isArabic ? 'العنوان' : 'Header'} | ${isArabic ? 'الوصف' : 'Description'} |\n|--------|-------------|\n| ${isArabic ? 'خلية' : 'Cell'}   | ${isArabic ? 'محتوى' : 'Content'}  |',
                      preview: isArabic ? 'جدول' : 'Table',
                      description: isArabic ? 'إنشاء جدول' : 'Create a table',
                      theme: theme,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: Text(isArabic ? 'إغلاق' : 'Close'),
          ),
        ],
      ),
    );
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
              color: theme.primaryColor,
            ),
          ),
        ),
        ...items,
      ],
    );
  }
}
