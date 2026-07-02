import 'package:flutter/material.dart';

class SoftCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;
  final bool pressed;
  final VoidCallback? onTap;

  const SoftCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.pressed = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? const Color(0xFF0F1012) : const Color(0xFFF4F6F6);
    final surface = isDark ? const Color(0xFF1A1C20) : const Color(0xFFF4F6F6);

    final shadowDark = isDark ? Colors.black.withOpacity(.55) : const Color(0xFFD1D9E6);
    final shadowLight = isDark ? Colors.white.withOpacity(.06) : Colors.white;

    final shadows = pressed
        ? [
      BoxShadow(color: shadowDark, offset: const Offset(-4, -4), blurRadius: 10),
      BoxShadow(color: shadowLight, offset: const Offset(4, 4), blurRadius: 10),
    ]
        : [
      BoxShadow(color: shadowLight, offset: const Offset(-6, -6), blurRadius: 16),
      BoxShadow(color: shadowDark, offset: const Offset(6, 6), blurRadius: 16),
    ];

    final card = AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: padding,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: borderRadius,
        boxShadow: shadows,
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(.06) : Colors.black.withOpacity(.03),
        ),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return Material(
      color: bg,
      child: InkWell(onTap: onTap, borderRadius: borderRadius, child: card),
    );
  }
}
