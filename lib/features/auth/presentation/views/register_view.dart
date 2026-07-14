import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/system_design/widgets/app_filled_button.dart';
import '../state/auth_providers.dart';
import '../widgets/auth_text_field.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF1E6EF2)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E2229),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Create an account to get started',
                style: TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 28),
              // Name
              AuthTextField(
                controller: _nameController,
                hintText: 'Your name',
                label: 'Name',
              ),
              const SizedBox(height: 18),
              // Email
              AuthTextField(
                controller: _emailController,
                hintText: 'name@email.com',
                label: 'Email Address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 18),
              // Password
              AuthTextField(
                controller: _passwordController,
                hintText: 'Create a password',
                label: 'Password',
                obscure: _obscurePassword,
                onToggleObscure: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
              const SizedBox(height: 18),
              // Confirm password
              AuthTextField(
                controller: _confirmPasswordController,
                hintText: 'Confirm password',
                obscure: _obscureConfirm,
                onToggleObscure: () {
                  setState(() => _obscureConfirm = !_obscureConfirm);
                },
              ),
              const SizedBox(height: 18),
              // Terms checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                    child: Container(
                      width: 20,
                      height: 20,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: _acceptedTerms
                            ? const Color(0xFF1E6EF2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: _acceptedTerms
                              ? const Color(0xFF1E6EF2)
                              : const Color(0xFFD1D5DB),
                        ),
                      ),
                      child: _acceptedTerms
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        children: [
                          TextSpan(text: "I've read and agree with the "),
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                              color: Color(0xFF1E6EF2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: ' and the '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: Color(0xFF1E6EF2),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
              // Register button
              AppFilledButton(
                text: 'Sign up',
                onPressed: state.isLoading ? null : _handleRegister,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the terms and conditions')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    final controller = ref.read(authControllerProvider.notifier);
    final success = await controller.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }
}
