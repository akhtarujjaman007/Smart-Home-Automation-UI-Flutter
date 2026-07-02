import 'package:flutter/material.dart';
import 'core/app_controller.dart';
import 'theme/app_theme.dart';
import 'ui/auth/auth_shell.dart';
import 'ui/main/main_shell.dart';

void main() => runApp(const SmartHomeApp());

class SmartHomeApp extends StatefulWidget {
  const SmartHomeApp({super.key});

  @override
  State<SmartHomeApp> createState() => _SmartHomeAppState();
}

class _SmartHomeAppState extends State<SmartHomeApp> {
  final app = AppController();
  bool dark = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (_, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          home: app.session == null
              ? AuthShell(
            onLogin: app.login,
            onRegister: app.register,
            onForgot: app.forgotPassword,
          )
              : MainShell(
            app: app,
            isDark: dark,
            onToggleTheme: () => setState(() => dark = !dark),
          ),
        );
      },
    );
  }
}
