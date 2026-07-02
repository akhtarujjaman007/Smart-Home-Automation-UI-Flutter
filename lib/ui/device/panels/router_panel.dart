import 'package:flutter/material.dart';
import '../../../core/app_controller.dart';
import '../../../models/device.dart';
import '../../widgets/soft_card.dart';

class RouterPanel extends StatelessWidget {
  final AppController app;
  final SmartDevice d;

  const RouterPanel({super.key, required this.app, required this.d});

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
              Text("${d.speedMbps} mbps", style: t.headlineSmall),
              const SizedBox(height: 2),
              Text("Current speed", style: TextStyle(color: sub)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.wifi_rounded),
                  const SizedBox(width: 10),
                  Text("Signal: ${d.wifiStrength}%", style: const TextStyle(fontWeight: FontWeight.w900)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
