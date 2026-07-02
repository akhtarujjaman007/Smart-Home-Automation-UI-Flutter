import 'package:flutter/material.dart';
import '../../../core/app_controller.dart';
import '../../../models/device.dart';
import '../../widgets/soft_card.dart';

class SpeakerPanel extends StatelessWidget {
  final AppController app;
  final SmartDevice d;

  const SpeakerPanel({super.key, required this.app, required this.d});

  @override
  Widget build(BuildContext context) {
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

        Center(
          child: SoftCard(
            padding: const EdgeInsets.all(22),
            borderRadius: BorderRadius.circular(26),
            child: Icon(Icons.speaker_rounded, size: 150, color: onSurface.withOpacity(.9)),
          ),
        ),

        const SizedBox(height: 14),

        SoftCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Text("Volume", style: TextStyle(fontWeight: FontWeight.w900, color: sub)),
              const SizedBox(width: 10),
              Expanded(child: Slider(value: d.volume, onChanged: (v) => app.setVolume(d, v))),
              Text("${(d.volume * 100).round()}%", style: TextStyle(fontWeight: FontWeight.w900, color: sub)),
            ],
          ),
        ),

        const SizedBox(height: 14),

        SoftCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Now playing", style: TextStyle(fontWeight: FontWeight.w900, color: sub)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => app.togglePlayback(d),
                    icon: Icon(d.playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  ),
                ],
              ),
              Slider(value: 0.55, onChanged: (_) {}),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.fast_rewind_rounded),
                  Icon(Icons.play_circle_fill_rounded, size: 34),
                  Icon(Icons.fast_forward_rounded),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
