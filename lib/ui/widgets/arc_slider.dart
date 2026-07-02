import 'dart:math';
import 'package:flutter/material.dart';

class ArcSlider extends StatelessWidget {
  final double value; // 0..1
  final ValueChanged<double> onChanged;

  const ArcSlider({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final size = min(c.maxWidth, 280.0);
        final onSurface = Theme.of(context).colorScheme.onSurface;

        return Center(
          child: GestureDetector(
            onPanUpdate: (d) {
              final delta = d.delta.dx - d.delta.dy;
              onChanged((value + delta / 650).clamp(0.0, 1.0));
            },
            child: CustomPaint(
              size: Size(size, size * 0.72),
              painter: _ArcPainter(value: value, onSurface: onSurface),
            ),
          ),
        );
      },
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double value;
  final Color onSurface;

  _ArcPainter({required this.value, required this.onSurface});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height);
    final radius = size.height * 0.95;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..color = onSurface.withOpacity(0.12);

    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..color = onSurface;

    const start = pi;
    const sweepTotal = pi;
    final sweepActive = sweepTotal * value;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweepTotal, false, basePaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweepActive, false, activePaint);

    final angle = start + sweepActive;
    final knob = Offset(center.dx + radius * cos(angle), center.dy + radius * sin(angle));
    canvas.drawCircle(knob, 10, Paint()..color = onSurface);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) => oldDelegate.value != value;
}
