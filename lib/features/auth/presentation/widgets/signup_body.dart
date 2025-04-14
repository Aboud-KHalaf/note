import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/helpers/functions/ui_functions.dart';
import 'package:note/core/helpers/localization/app_localization.dart';
import 'package:note/core/helpers/providers/animations_provider.dart';
import 'package:note/core/helpers/styles/fonts_h.dart';
import 'package:note/core/helpers/styles/spacing_h.dart';
import 'package:note/core/utils/validators.dart';
import 'package:note/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:note/features/auth/presentation/widgets/animation_box_w.dart';
import 'package:note/features/notes/presentation/views/home_view.dart';

import '../manager/get_user_cubit/get_user_cubit.dart';
import 'custom_material_button_w.dart';
import '../../../../core/widgets/custom_text_form_field_w.dart';
import 'go_to_login.dart_w.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmPasswordFocusNode;

  bool firstValidate = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeFocusNodes();
    _addListenersToControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _initializeFocusNodes() {
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _confirmPasswordFocusNode = FocusNode();
  }

  void _addListenersToControllers() {
    _nameController.addListener(_revalidateForm);
    _emailController.addListener(_revalidateForm);
    _passwordController.addListener(_revalidateForm);
    _confirmPasswordController.addListener(_revalidateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
      BlocProvider.of<AuthCubit>(context).signUp(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
                  const AnimationBox(animation: AnimationsProvider.login),
                  _buildGoogleButton(),
                  SpacingHelper.h2,
                  Text(
                    'create_new_account'.tr(context),
                    style: FontsStylesHelper.textStyle33,
                    textAlign: TextAlign.center,
                  ),
                  SpacingHelper.h2,
                  _buildNameField(),
                  SpacingHelper.h2,
                  _buildEmailField(),
                  SpacingHelper.h2,
                  _buildPasswordField(),
                  SpacingHelper.h2,
                  _buildConfirmPasswordField(),
                  const Expanded(child: SizedBox(height: 20)),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _buildAuthContent(state, theme.primaryColor),
                      );
                    },
                  ),
                  SpacingHelper.h2,
                  const GoToSignIn(),
                  SpacingHelper.h3,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAuthContent(AuthState state, Color color) {
    if (state is AuthLoading) {
      return buildLoadingIndicator(Colors.cyan);
    } else if (state is AuthFailure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAnimatedSnackBar(context, Colors.red, state.errMessage);
      });
      return _buildSignUpButton(color);
    } else if (state is AuthSuccess) {
      final currentContext = context;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await BlocProvider.of<GetUserCubit>(currentContext).getUserData();
          if (currentContext.mounted) {
            showAnimatedSnackBar(
                currentContext, Colors.green, 'sign up success');
            Navigator.of(currentContext).pushReplacementNamed(HomeView.id);
          }
        } catch (e) {
          if (currentContext.mounted) {
            showAnimatedSnackBar(
                currentContext, Colors.red, 'Failed to load user data');
          }
        }
      });
    }
    return _buildSignUpButton(color);
  }

  Widget _buildGoogleButton() {
    return CustomMaterialButton(
      text: "continue_with_google".tr(context),
      color: Colors.white,
      onPressed: () async {
        context.read<AuthCubit>().googleSignIn();
      },
    );
  }

  Widget _buildNameField() {
    return CustomTextFormFieldWidget(
      controller: _nameController,
      focusNode: _nameFocusNode,
      validator: Validators.validateName,
      hintText: 'enter_name'.tr(context),
      suffixIcon: const Icon(Icons.person),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_emailFocusNode),
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
      obscureText: true,
      validator: Validators.validatePassword,
      hintText: 'enter_password'.tr(context),
      suffixIcon: const Icon(Icons.lock),
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) =>
          FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
    );
  }

  Widget _buildConfirmPasswordField() {
    return CustomTextFormFieldWidget(
      controller: _confirmPasswordController,
      focusNode: _confirmPasswordFocusNode,
      validator: (value) => Validators.validateConfirmPassword(
          value, _passwordController.text.trim()),
      hintText: 'confirm_password'.tr(context),
      obscureText: true,
      suffixIcon: const Icon(Icons.password),
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildSignUpButton(Color color) {
    return CustomMaterialButton(
      text: "sign_up".tr(context),
      color: color,
      onPressed: _submitForm,
    );
  }
}
