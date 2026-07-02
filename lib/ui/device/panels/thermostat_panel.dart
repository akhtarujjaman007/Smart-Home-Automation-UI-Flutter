import 'package:flutter/material.dart';
import '../../../core/app_controller.dart';
import '../../../models/device.dart';
import '../../widgets/soft_card.dart';

class ThermostatPanel extends StatelessWidget {
  final AppController app;
  final SmartDevice d;

  const ThermostatPanel({super.key, required this.app, required this.d});

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
              Text("${d.temperature.toStringAsFixed(0)}°C", style: t.headlineSmall),
              const SizedBox(height: 2),
              Text("Target temperature", style: t.bodyMedium?.copyWith(color: sub)),
              const SizedBox(height: 10),
              Slider(min: 10, max: 35, value: d.temperature, onChanged: (v) => app.setTemperature(d, v)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("10°C", style: TextStyle(color: sub, fontWeight: FontWeight.w700)),
                  Text("35°C", style: TextStyle(color: sub, fontWeight: FontWeight.w700)),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),
        Text("Mode", style: t.titleMedium),
        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(child: _ModeChip(selected: d.thermoMode == "Auto", label: "Auto", onTap: () => app.setThermoMode(d, "Auto"))),
            const SizedBox(width: 10),
            Expanded(child: _ModeChip(selected: d.thermoMode == "Cool", label: "Cool", onTap: () => app.setThermoMode(d, "Cool"))),
            const SizedBox(width: 10),
            Expanded(child: _ModeChip(selected: d.thermoMode == "Heat", label: "Heat", onTap: () => app.setThermoMode(d, "Heat"))),
          ],
        ),

        const SizedBox(height: 14),
        SoftCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.air_rounded),
              const SizedBox(width: 10),
              Expanded(child: Text("Fan: Normal", style: TextStyle(fontWeight: FontWeight.w900, color: sub))),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ],
    );
  }
}

class _ModeChip extends StatelessWidget {
  final bool selected;
  final String label;
  final VoidCallback onTap;

  const _ModeChip({required this.selected, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      pressed: selected,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Center(
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w900, color: selected ? Colors.blueAccent : null),
        ),
      ),
    );
  }
}
