import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:note/core/helpers/colors/app_colors.dart';

class ColorSelectionSheet extends StatefulWidget {
  final Function(int) onColorSelected;
  final int idx;

  const ColorSelectionSheet({
    super.key,
    required this.onColorSelected,
    required this.idx,
  });

  @override
  State<ColorSelectionSheet> createState() => _ColorSelectionSheetState();
}

class _ColorSelectionSheetState extends State<ColorSelectionSheet> {
  late int currentIdx;
  @override
  void initState() {
    currentIdx = widget.idx;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: AppColors.cardColors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.onColorSelected(index);
                  setState(() {
                    currentIdx = index;
                  });
                },
                borderRadius: BorderRadius.circular(50),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: index == currentIdx
                              ? theme.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: AppColors.cardColors[index],
                        radius: 20,
                      ),
                    ),
                    if (index == currentIdx)
                      Icon(
                        Icons.check,
                        size: 28,
                        color: theme.primaryColor,
                      ),
                  ],
                ),
              ),
            )
                .animate(delay: Duration(milliseconds: index * 30))
                .scale(duration: const Duration(milliseconds: 200))
                .fade(duration: const Duration(milliseconds: 200)),
          );
        },
      ),
    );
  }
}
