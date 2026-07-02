import 'package:flutter/material.dart';
import 'soft_card.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1A1C20) : const Color(0xFFF4F6F6);

    return SoftCard(
      pressed: true,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 54,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: bg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          onPressed: onPressed,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
              color: Colors.blueAccent,
            ),
          ),
        ),
      ),
    );
  }
}
