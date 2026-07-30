import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/localization/locale_provider.dart';
import '../../core/theme/app_theme.dart';
import 'auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    await ref.read(authProvider.notifier).login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Dil seçici
              Align(
                alignment: Alignment.center,
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  isSelected: [currentLocale.languageCode == 'tr', currentLocale.languageCode == 'ar'],
                  onPressed: (index) {
                    ref.read(localeProvider.notifier).setLocale(index == 0 ? 'tr' : 'ar');
                  },
                  children: const [
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('TR')),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('AR')),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Icon(Icons.shield_moon, size: 64, color: AppColors.gold),
              const SizedBox(height: 12),
              Text(
                context.t('app_name'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: context.t('username')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: context.t('password')),
              ),
              const SizedBox(height: 8),
              if (authState.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    authState.errorMessage!,
                    style: const TextStyle(color: AppColors.danger),
                  ),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                      )
                    : Text(context.t('login_button')),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text(context.t('forgot_password')),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
