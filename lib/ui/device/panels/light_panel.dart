import 'package:flutter/material.dart';
import '../../../core/app_controller.dart';
import '../../../models/device.dart';
import '../../widgets/arc_slider.dart';
import '../../widgets/soft_card.dart';

class LightPanel extends StatelessWidget {
  final AppController app;
  final SmartDevice d;

  const LightPanel({super.key, required this.app, required this.d});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final sub = onSurface.withOpacity(0.65);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(d.icon),
              const SizedBox(width: 10),
              const Text("Power", style: TextStyle(fontWeight: FontWeight.w900)),
              const Spacer(),
              Switch(value: d.isOn, onChanged: (v) => app.togglePower(d, v)),
            ],
          ),
        ),
        const SizedBox(height: 14),

        SoftCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${(d.brightness * 100).round()}%", style: t.headlineSmall),
              const SizedBox(height: 2),
              Text("Brightness", style: t.bodyMedium?.copyWith(color: sub)),
              const SizedBox(height: 14),
              ArcSlider(value: d.brightness, onChanged: (v) => app.setBrightness(d, v)),
            ],
          ),
        ),

        const SizedBox(height: 14),

        Text("Intensity", style: t.titleMedium),
        const SizedBox(height: 10),
        SoftCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Text("off", style: TextStyle(fontWeight: FontWeight.w800, color: sub)),
              Expanded(child: Slider(value: d.intensity, onChanged: (v) => app.setIntensity(d, v))),
              Text("${(d.intensity * 100).round()}%", style: const TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ],
    );
  }
}
