import 'package:flutter/material.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/providers/images_provider.dart';
import 'package:note/features/auth/presentation/views/first_view.dart';
import 'package:note/features/on_boarding/presentation/widgets/bottom_sheet_navigation.dart';
import 'package:note/features/on_boarding/presentation/widgets/on_boarding_page.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'onboarding_note_writing_title',
      'description': 'onboarding_note_writing',
      'image': ImagesProvider.note,
    },
    {
      'title': 'onboarding_note_organizing_title',
      'description': 'onboarding_note_organizing',
      'image': ImagesProvider.folders,
    },
    {
      'title': 'onboarding_note_searching_title',
      'description': 'onboarding_note_searching',
      'image': ImagesProvider.search,
    },
    {
      'title': 'onboarding_note_syncing_title',
      'description': 'onboarding_note_syncing',
      'image': ImagesProvider.sync,
    },
  ];

  void _goToNextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(context, FirstView.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          final data = _onboardingData[index];
          return OnBoardingPage(
            title: data['title']!.tr(context),
            description: data['description']!.tr(context),
            image: data['image']!,
          );
        },
      ),
      bottomSheet: BottomSheetNavigation(
        currentPage: _currentPage,
        totalPages: _onboardingData.length,
        onNext: _goToNextPage,
        onSkip: _finishOnboarding,
      ),
    );
  }
}
