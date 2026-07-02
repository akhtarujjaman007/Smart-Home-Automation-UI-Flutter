import 'package:flutter/material.dart';
import '../../core/app_controller.dart';
import '../../models/room.dart';
import '../device/device_detail_page.dart';
import '../rooms/room_detail_page.dart';
import '../widgets/device_card.dart';
import '../widgets/room_chip.dart';
import '../widgets/soft_card.dart';

class RoomsDashboard extends StatefulWidget {
  final AppController app;
  const RoomsDashboard({super.key, required this.app});

  @override
  State<RoomsDashboard> createState() => _RoomsDashboardState();
}

class _RoomsDashboardState extends State<RoomsDashboard> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    final rooms = widget.app.rooms;
    if (rooms.isEmpty) {
      return const Center(child: Text("No rooms yet. Tap + to create one."));
    }

    selected = selected.clamp(0, rooms.length - 1);
    final room = rooms[selected];
    final devices = widget.app.devicesInRoom(room.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: rooms.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => RoomChip(
              label: rooms[i].name,
              selected: i == selected,
              onTap: () => setState(() => selected = i),
            ),
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: SoftCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.meeting_room_rounded),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(room.name, style: const TextStyle(fontWeight: FontWeight.w900), overflow: TextOverflow.ellipsis),
                    ),
                    IconButton(onPressed: () => _renameRoom(context, room), icon: const Icon(Icons.edit_rounded)),
                    IconButton(onPressed: () => _deleteRoom(context, room), icon: const Icon(Icons.delete_outline_rounded)),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SoftCard(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => RoomDetailPage(app: widget.app, room: room)),
            );
          },
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: const Row(
            children: [
              Icon(Icons.tune_rounded),
              SizedBox(width: 10),
              Expanded(child: Text("Open room controls", style: TextStyle(fontWeight: FontWeight.w800))),
              Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),

        const SizedBox(height: 12),

        Expanded(
          child: GridView.builder(
            itemCount: devices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (_, i) {
              final d = devices[i];
              return DeviceCard(
                device: d,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DeviceDetailPage(app: widget.app, device: d)),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _renameRoom(BuildContext context, Room room) async {
    final c = TextEditingController(text: room.name);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rename room"),
        content: TextField(controller: c, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text("Save")),
        ],
      ),
    );
    if (ok == true) widget.app.renameRoom(room, c.text);
  }

  Future<void> _deleteRoom(BuildContext context, Room room) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete room?"),
        content: const Text("Devices in this room will become unassigned."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );
    if (ok == true) widget.app.deleteRoom(room);
  }
}
