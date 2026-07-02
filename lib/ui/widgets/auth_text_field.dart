import 'package:flutter/material.dart';
import 'soft_card.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscure ? hide : false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hint,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.obscure
              ? IconButton(
            onPressed: () => setState(() => hide = !hide),
            icon: Icon(hide ? Icons.visibility_off_rounded : Icons.visibility_rounded),
          )
              : null,
        ),
      ),
    );
  }
}
