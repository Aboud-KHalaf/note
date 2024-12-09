import 'package:flutter/material.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';

class OnBoardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnBoardingPage({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 200,
          ),
          const SizedBox(height: 30),
          Text(title,
              style: FontsStylesHelper.textStyle24
                  .copyWith(color: Theme.of(context).primaryColor)),
          const SizedBox(height: 20),
          Text(
            description,
            style: FontsStylesHelper.textStyle16,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
