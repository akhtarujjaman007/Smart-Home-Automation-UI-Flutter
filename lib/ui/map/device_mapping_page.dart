import 'package:flutter/material.dart';
import '../../core/app_controller.dart';
import '../widgets/soft_card.dart';

class DeviceMappingPage extends StatelessWidget {
  final AppController app;
  const DeviceMappingPage({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final unassigned = app.unassignedDevices();
    final rooms = app.rooms;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.info_outline_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Assign (map) devices to rooms. Unassigned devices will not appear in room controls.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: onSurface.withOpacity(0.75)),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        Text("Unassigned devices", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),

        Expanded(
          child: unassigned.isEmpty
              ? const Center(child: Text("No unassigned devices."))
              : ListView.separated(
            itemCount: unassigned.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) {
              final d = unassigned[i];
              return SoftCard(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Icon(d.icon, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(d.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text("Type: ${d.type.name}", style: TextStyle(color: onSurface.withOpacity(0.65))),
                        ],
                      ),
                    ),
                    DropdownButton<String>(
                      value: null,
                      hint: const Text("Assign"),
                      items: rooms.map((r) => DropdownMenuItem(value: r.id, child: Text(r.name))).toList(),
                      onChanged: (roomId) {
                        if (roomId == null) return;
                        app.assignDeviceToRoom(d, roomId);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${d.name} assigned")));
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
