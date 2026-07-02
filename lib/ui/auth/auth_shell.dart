import 'package:flutter/material.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/primary_button.dart';
import '../widgets/soft_card.dart';

enum AuthView { login, register, forgot }

class AuthShell extends StatefulWidget {
  final Future<String?> Function(String email, String password) onLogin;
  final Future<String?> Function(String name, String email, String password) onRegister;
  final Future<String?> Function(String email) onForgot;

  const AuthShell({
    super.key,
    required this.onLogin,
    required this.onRegister,
    required this.onForgot,
  });

  @override
  State<AuthShell> createState() => _AuthShellState();
}

class _AuthShellState extends State<AuthShell> {
  AuthView view = AuthView.login;

  final emailC = TextEditingController(text: "sujon@gmail.com");
  final passC = TextEditingController(text: "123456");

  final nameC = TextEditingController();
  final regEmailC = TextEditingController();
  final regPassC = TextEditingController();

  final forgotEmailC = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    nameC.dispose();
    regEmailC.dispose();
    regPassC.dispose();
    forgotEmailC.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => loading = true);
    String? error;

    if (view == AuthView.login) {
      error = await widget.onLogin(emailC.text.trim(), passC.text);
    } else if (view == AuthView.register) {
      error = await widget.onRegister(nameC.text, regEmailC.text.trim(), regPassC.text);
    } else {
      error = await widget.onForgot(forgotEmailC.text.trim());
      if (error == null) _toast("Reset link sent (demo)");
    }

    if (error != null) _toast(error);
    setState(() => loading = false);
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Column(
                  key: ValueKey(view),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 6),
                    Center(
                      child: SoftCard(
                        padding: const EdgeInsets.all(22),
                        borderRadius: BorderRadius.circular(999),
                        child: const Icon(Icons.home_rounded, size: 52, color: Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(_titleFor(view), style: t.titleLarge, textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text(
                      _subtitleFor(view),
                      style: t.bodyMedium?.copyWith(height: 1.3, color: onSurface.withOpacity(0.7)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    if (view == AuthView.login) ...[
                      AuthTextField(controller: emailC, hint: "Email", icon: Icons.email_outlined),
                      const SizedBox(height: 12),
                      AuthTextField(controller: passC, hint: "Password", icon: Icons.lock_outline, obscure: true),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => setState(() => view = AuthView.forgot),
                          child: const Text("Forgot password?"),
                        ),
                      ),
                      const SizedBox(height: 8),
                      PrimaryButton(
                        text: loading ? "Signing in..." : "Sign in",
                        onPressed: loading ? null : _submit,
                      ),
                      const SizedBox(height: 14),
                      _SwitchLine(
                        text: "Don’t have an account?",
                        action: "Sign up",
                        onTap: () => setState(() => view = AuthView.register),
                      ),
                    ],

                    if (view == AuthView.register) ...[
                      AuthTextField(controller: nameC, hint: "Full name", icon: Icons.person_outline),
                      const SizedBox(height: 12),
                      AuthTextField(controller: regEmailC, hint: "Email", icon: Icons.email_outlined),
                      const SizedBox(height: 12),
                      AuthTextField(controller: regPassC, hint: "Password", icon: Icons.lock_outline, obscure: true),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: loading ? "Creating..." : "Create account",
                        onPressed: loading ? null : _submit,
                      ),
                      const SizedBox(height: 14),
                      _SwitchLine(
                        text: "Already have an account?",
                        action: "Login",
                        onTap: () => setState(() => view = AuthView.login),
                      ),
                    ],

                    if (view == AuthView.forgot) ...[
                      AuthTextField(controller: forgotEmailC, hint: "Email", icon: Icons.email_outlined),
                      const SizedBox(height: 12),
                      PrimaryButton(
                        text: loading ? "Sending..." : "Send reset link",
                        onPressed: loading ? null : _submit,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() => view = AuthView.login),
                        child: const Text("Back to login"),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _titleFor(AuthView v) {
    switch (v) {
      case AuthView.login:
        return "Welcome back";
      case AuthView.register:
        return "Create account";
      case AuthView.forgot:
        return "Reset password";
    }
  }

  String _subtitleFor(AuthView v) {
    switch (v) {
      case AuthView.login:
        return "Sign in to control your smart home";
      case AuthView.register:
        return "Create your account to manage devices";
      case AuthView.forgot:
        return "We’ll email you a secure reset link (demo)";
    }
  }
}

class _SwitchLine extends StatelessWidget {
  final String text;
  final String action;
  final VoidCallback onTap;

  const _SwitchLine({required this.text, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        TextButton(onPressed: onTap, child: Text(action, style: const TextStyle(fontWeight: FontWeight.w900))),
      ],
    );
  }
}
