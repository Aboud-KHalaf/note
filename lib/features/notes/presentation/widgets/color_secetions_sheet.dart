import 'package:flutter/material.dart';
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      height: 80,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: AppColors.cardColors.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              IconButton(
                onPressed: () {
                  widget.onColorSelected(index);
                  setState(() {
                    currentIdx = index;
                  });
                },
                icon: CircleAvatar(
                  backgroundColor:
                      (index == currentIdx) ? theme.primaryColor : Colors.white,
                  radius: 22,
                  child: CircleAvatar(
                    backgroundColor: AppColors.cardColors[index],
                    radius: 20,
                  ),
                ),
              ),
              (index == currentIdx)
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 38,
                        color: theme.primaryColor,
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
