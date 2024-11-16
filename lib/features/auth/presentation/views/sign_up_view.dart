import 'package:flutter/material.dart';
import 'package:note/features/auth/presentation/widgets/signup_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  static String id = '/sign up';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SignUpViewBody(),
    );
  }
}
