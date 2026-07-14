import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:experience_app/features/auth/presentation/state/auth_providers.dart';
import 'package:experience_app/features/auth/presentation/views/login_view.dart';
import 'package:experience_app/system_design/widgets/app_filled_button.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F7),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 18),
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 46,
                  backgroundColor: const Color(0xFFDCE4F2),
                  child: Text(
                    _userInitial(user?.name),
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5D6B82),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E6EF2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              user?.name ?? 'Guest user',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email != null && user!.email.contains('@')
                  ? '@${user.email.split('@').first}'
                  : '@guestuser',
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                color: const Color(0xFFF3F4F7),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: [
                    _settingsTile(label: 'Saved Messages'),
                    _settingsTile(label: 'Recent Calls'),
                    _settingsTile(label: 'Devices'),
                    _settingsTile(label: 'Notifications'),
                    _settingsTile(label: 'Appearance'),
                    _settingsTile(label: 'Language'),
                    _settingsTile(label: 'Privacy & Security'),
                    _settingsTile(label: 'Storage'),
                    const SizedBox(height: 10),
                    AppFilledButton(
                      text: 'Cerrar sesion',
                      onPressed: () => _logout(context, ref),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({required String label}) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFD9DEE7),
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 28,
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 30,
          color: Color(0xFF8B93A1),
        ),
        onTap: () {},
      ),
    );
  }

  String _userInitial(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'U';
    }
    return name.trim()[0].toUpperCase();
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authControllerProvider.notifier).logout();
    if (!context.mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginView()),
      (route) => false,
    );
  }
}