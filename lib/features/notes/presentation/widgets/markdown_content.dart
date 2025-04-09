import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md; // Import markdown package

// Define the custom builder class outside the widget
class _LtrCodeBlockBuilder extends MarkdownElementBuilder {
  final BuildContext context;

  _LtrCodeBlockBuilder(this.context);

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final theme = Theme.of(context);
    final codeText = element.textContent;

    // Recreate the styling logic here
    final styleSheet = MarkdownStyleSheet.fromTheme(theme);
    final codeStyle = styleSheet.code ??
        theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace') ??
        const TextStyle(fontFamily: 'monospace');
    final codeBlockPadding =
        styleSheet.codeblockPadding ?? const EdgeInsets.all(8.0);
    final codeBlockDecoration = styleSheet.codeblockDecoration ??
        BoxDecoration(color: theme.colorScheme.surfaceContainerHighest);

    return Directionality(
      textDirection: TextDirection.ltr, // Force LTR for code block
      child: Container(
        decoration: codeBlockDecoration,
        padding: codeBlockPadding,
        margin: EdgeInsets.symmetric(
            vertical: (styleSheet.blockSpacing ?? 8.0) / 2),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            codeText,
            style: codeStyle,
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}

class MarkdownContent extends StatelessWidget {
  final String content;
  final TextDirection direction; // Overall direction for non-code text
  final EdgeInsets? padding;

  const MarkdownContent({
    super.key,
    required this.content,
    required this.direction,
    this.padding,
  });

  // --- Helper function to create the MarkdownStyleSheet ---
  MarkdownStyleSheet _buildStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final baseTextStyle = textTheme.bodyLarge ?? const TextStyle();
    final codeBackgroundColor = theme.brightness == Brightness.dark
        ? Colors.grey.shade800.withOpacity(0.7)
        : Colors.grey.shade200.withOpacity(0.7);
    final codeTextStyle = textTheme.bodyMedium?.copyWith(
          fontFamily: 'monospace',
          backgroundColor: Colors.transparent,
          color: textTheme.bodyMedium?.color?.withOpacity(0.85),
        ) ??
        const TextStyle(fontFamily: 'monospace');

    return MarkdownStyleSheet(
      p: baseTextStyle,
      pPadding: const EdgeInsets.symmetric(vertical: 4.0), // Uses EdgeInsets
      blockSpacing: 8.0,
      h1: textTheme.headlineLarge,
      // ... other headers ...
      h1Padding: const EdgeInsets.only(top: 16, bottom: 8), // Uses EdgeInsets
      // ... other header paddings ...
      a: baseTextStyle.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
        decorationColor: colorScheme.primary,
      ),
      code: codeTextStyle.copyWith(
        backgroundColor: codeBackgroundColor.withOpacity(0.5),
        fontSize: (codeTextStyle.fontSize ?? 14) * 0.9,
      ),
      codeblockPadding: const EdgeInsets.all(12.0), // Uses EdgeInsets
      codeblockDecoration: BoxDecoration(
        color: codeBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      blockquote: baseTextStyle.copyWith(
        color: baseTextStyle.color?.withOpacity(0.75),
      ),
      blockquotePadding: const EdgeInsets.all(12.0), // Uses EdgeInsets
      blockquoteDecoration: BoxDecoration(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
          border: Border(
            left: BorderSide(
              color: theme.dividerColor,
              width: 4.0,
            ),
          ),
          borderRadius: BorderRadius.circular(4.0)),
      listBullet: baseTextStyle,
      listBulletPadding:
          const EdgeInsets.only(right: 8.0, top: 2.0), // Uses EdgeInsets
      listIndent: 24.0,
      tableHead: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      tableBody: textTheme.bodyMedium,
      tableBorder: TableBorder.all(
        color: theme.dividerColor,
        width: 1.0,
      ),
      tableHeadAlign: TextAlign.center,
      // --- FIX 1 ---
      tableCellsPadding: const EdgeInsets.all(
          8.0), // Use tableCellsPadding (plural), uses EdgeInsets
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            width: 1.0,
            color: theme.dividerColor,
          ),
        ),
      ),
    );
  }

  // --- Link Tapping Logic (no changes needed here) ---
  Future<void> _onTapLink(String text, String? href, String title) async {
    if (href == null) return;
    final Uri url = Uri.parse(href);
    try {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Could not launch $href: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Capture the stylesheet and context here for the builder
    final styleSheet = _buildStyleSheet(context);
    final capturedContext = context;

    return Directionality(
      textDirection: direction, // Set overall direction
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 0,
          maxHeight: double.infinity,
        ),
        child: Markdown(
          data: content,
          padding: padding ?? const EdgeInsets.all(16.0),
          styleSheet: styleSheet,
          onTapLink: _onTapLink,
          builders: {
            'codeblock': _LtrCodeBlockBuilder(capturedContext),
          },
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
