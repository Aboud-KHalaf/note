import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';

class BottomSheetNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const BottomSheetNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onSkip,
            child: Text(
              'skip'.tr(context),
              style: TextStyle(
                color: currentPage == totalPages - 1
                    ? Colors.grey
                    : Colors.blueAccent,
                fontSize: 16,
              ),
            ),
          ),
          Row(
            children: List.generate(
              totalPages,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: currentPage == index ? 16 : 8,
                decoration: BoxDecoration(
                  color:
                      currentPage == index ? theme.hintColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: onNext,
            child: Text(
              currentPage == totalPages - 1
                  ? 'finish'.tr(context)
                  : 'next'.tr(context),
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
