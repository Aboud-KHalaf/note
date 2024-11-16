import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:note/core/helpers/styles/sizes_h.dart';

class AnimationBox extends StatelessWidget {
  const AnimationBox({
    super.key,
    required this.animation,
  });

  final String animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizesHelper.screenHeight(context) * 0.4,
      width: double.infinity,
      child: Lottie.asset(
        animation,
        repeat: true,
      ),
    );
  }
}
