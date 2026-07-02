import 'package:flutter/material.dart';
import '../../core/app_controller.dart';
import '../../models/room.dart';
import '../device/device_detail_page.dart';
import '../widgets/device_card.dart';
import '../widgets/soft_card.dart';

class RoomDetailPage extends StatelessWidget {
  final AppController app;
  final Room room;

  const RoomDetailPage({super.key, required this.app, required this.room});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (_, __) {
        final devices = app.devicesInRoom(room.id);

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                      const SizedBox(width: 6),
                      Expanded(child: Text(room.name, style: Theme.of(context).textTheme.titleLarge)),
                      IconButton(
                        tooltip: "Add devices",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => QuickAssignToRoomPage(app: app, room: room)),
                          );
                        },
                        icon: const Icon(Icons.add_circle_outline_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  SoftCard(
                    padding: const EdgeInsets.all(14),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline_rounded),
                        SizedBox(width: 10),
                        Expanded(child: Text("Tap a device to open its control system.")),
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DeviceDetailPage(app: app, device: d)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class QuickAssignToRoomPage extends StatelessWidget {
  final AppController app;
  final Room room;

  const QuickAssignToRoomPage({super.key, required this.app, required this.room});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (_, __) {
        final unassigned = app.unassignedDevices();

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text("Add devices to ${room.name}", style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (unassigned.isEmpty)
                    const Expanded(child: Center(child: Text("No unassigned devices.")))
                  else
                    Expanded(
                      child: ListView.separated(
                        itemCount: unassigned.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) {
                          final d = unassigned[i];
                          return SoftCard(
                            onTap: () {
                              app.assignDeviceToRoom(d, room.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("${d.name} added to ${room.name}")),
                              );
                            },
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
                                      Text("Tap to add", style: TextStyle(color: Theme.of(context).hintColor)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.add_rounded),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
