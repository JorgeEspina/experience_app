import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/system_design/widgets/app_filled_button.dart';
import 'package:experience_app/system_design/widgets/app_network_image.dart';
import 'package:experience_app/features/home/presentation/views/home_view.dart';
import '../state/auth_providers.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/social_login_buttons.dart';
import 'register_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header image
              const AppNetworkImage(
                imageUrl: null,
                height: 200,
                borderRadius: 0,
                placeholderIconSize: 48,
              ),
              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E2229),
                      ),
                    ),
                    const SizedBox(height: 28),
                    // Email
                    AuthTextField(
                      controller: _emailController,
                      hintText: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    // Password
                    AuthTextField(
                      controller: _passwordController,
                      hintText: 'Password',
                      obscure: _obscurePassword,
                      onToggleObscure: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Forgot password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Color(0xFF1E6EF2),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Error message
                    if (state.error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          state.error!,
                          style: const TextStyle(
                            color: Color(0xFFDC2626),
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    // Login button
                    AppFilledButton(
                      text: 'Login',
                      onPressed: state.isLoading ? null : _handleLogin,
                    ),
                    const SizedBox(height: 20),
                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member? ',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const RegisterView(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1E6EF2),
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF1E6EF2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Social buttons
                    const SocialLoginButtons(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final controller = ref.read(authControllerProvider.notifier);
    final success = await controller.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomeView()),
        (route) => false,
      );
    }
  }
}
