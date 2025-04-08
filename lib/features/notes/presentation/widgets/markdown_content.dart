import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownContent extends StatelessWidget {
  final String content;
  final TextDirection direction;

  const MarkdownContent({
    super.key,
    required this.content,
    required this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: direction,
      child: MarkdownBody(
        data: content,
        styleSheet: MarkdownStyleSheet(
          p: Theme.of(context).textTheme.bodyLarge,
          h1: Theme.of(context).textTheme.headlineLarge,
          h2: Theme.of(context).textTheme.headlineMedium,
          h3: Theme.of(context).textTheme.headlineSmall,
          blockquote: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.7),
              ),
          code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerHighest,
                fontFamily: 'monospace',
              ),
          listBullet: Theme.of(context).textTheme.bodyLarge,
          tableHead: Theme.of(context).textTheme.titleMedium,
          tableBody: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
