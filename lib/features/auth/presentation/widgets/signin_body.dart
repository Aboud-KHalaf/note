import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/colors/app_colors.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/providers/animations_provider.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';
import 'package:note/core/utils/validators.dart';
import 'package:note/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:note/features/auth/presentation/views/syncing_view.dart';
import 'package:note/features/auth/presentation/widgets/animation_box_w.dart';
import 'package:note/features/auth/presentation/widgets/go_to_get_started_w.dart';

import '../../../../core/helpers/functions/ui_functions.dart';
import 'custom_material_button_w.dart';
import '../../../../core/widgets/custom_text_form_field_w.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  bool firstValidate = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeFocusNodes();
    _addListenersToControllers();
  }

  void _initializeControllers() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  void _initializeFocusNodes() {
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  void _addListenersToControllers() {
    _emailController.addListener(_revalidateForm);
    _passwordController.addListener(_revalidateForm);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _revalidateForm() {
    if (firstValidate) {
      setState(() {
        _formKey.currentState?.validate();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthCubit>(context).signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  const AnimationBox(animation: AnimationsProvider.getStarted),
                  _buildGoogleButton(),
                  SpacingHelper.h2,
                  Text(
                    'login_to_your_account'.tr(context),
                    style: FontsStylesHelper.textStyle33,
                    textAlign: TextAlign.center,
                  ),
                  SpacingHelper.h2,
                  _buildEmailField(),
                  SpacingHelper.h2,
                  _buildPasswordField(),
                  const Expanded(child: SizedBox(height: 20)),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildAuthContent(state),
                      );
                    },
                  ),
                  SpacingHelper.h2,
                  const GoToSignUp(),
                  SpacingHelper.h3,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAuthContent(AuthState state) {
    if (state is AuthLoading) {
      return buildLoadingIndicator();
    } else if (state is AuthFailure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAnimatedSnackBar(context, Colors.red, state.errMessage);
      });
      return _buildSignUpButton();
    } else if (state is AuthSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAnimatedSnackBar(context, Colors.green, 'sign in success');
        Navigator.of(context).pushReplacementNamed(SyncingView.id);
      });
    }
    return _buildSignUpButton();
  }

  Widget _buildGoogleButton() {
    return CustomMaterialButton(
      text: "continue_with_google".tr(context),
      color: Colors.white,
      onPressed: () async {
//         await supabase.auth.signInWithOAuth(
//   OAuthProvider.google,
// );
      },
    );
  }

  Widget _buildEmailField() {
    return CustomTextFormFieldWidget(
      controller: _emailController,
      focusNode: _emailFocusNode,
      validator: Validators.validateEmail,
      hintText: 'enter_email'.tr(context),
      suffixIcon: const Icon(Icons.email),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_passwordFocusNode),
    );
  }

  Widget _buildPasswordField() {
    return CustomTextFormFieldWidget(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      validator: Validators.validatePassword,
      hintText: 'enter_password'.tr(context),
      suffixIcon: const Icon(Icons.lock),
      textInputAction: TextInputAction.next,
    );
  }

  Widget _buildSignUpButton() {
    return CustomMaterialButton(
      text: "sign_in".tr(context),
      color: AppColors.primary,
      onPressed: _submitForm,
    );
  }
}
