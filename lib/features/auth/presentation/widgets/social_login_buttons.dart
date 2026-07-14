import 'package:flutter/material.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Or continue with',
          style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _SocialButton(
              color: const Color(0xFFEA4335),
              icon: Icons.g_mobiledata,
            ),
            const SizedBox(width: 16),
            _SocialButton(
              color: const Color(0xFF1E2229),
              icon: Icons.apple,
            ),
            const SizedBox(width: 16),
            _SocialButton(
              color: const Color(0xFF1877F2),
              icon: Icons.facebook,
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 24),
    );
  }
}
