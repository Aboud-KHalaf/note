import 'package:flutter/material.dart';

import '../widgets/signin_body.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  static String id = '/login';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignInViewBody(),
    );
  }
}
