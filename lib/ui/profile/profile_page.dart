import 'package:flutter/material.dart';
import '../../core/app_controller.dart';
import '../../models/session.dart';
import '../widgets/soft_card.dart';

class ProfilePage extends StatelessWidget {
  final AppController app;
  final UserSession session;

  const ProfilePage({super.key, required this.app, required this.session});

  @override
  Widget build(BuildContext context) {
    final totalRooms = app.rooms.length;
    final totalDevices = app.devices.length;
    final assigned = app.devices.where((d) => d.roomId.isNotEmpty).length;

    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SoftCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const CircleAvatar(radius: 22, child: Icon(Icons.person)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(session.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(session.email, style: TextStyle(color: onSurface.withOpacity(0.65))),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(child: _StatCard(label: "Rooms", value: "$totalRooms")),
            const SizedBox(width: 12),
            Expanded(child: _StatCard(label: "Devices", value: "$totalDevices")),
          ],
        ),
        const SizedBox(height: 12),
        _StatCard(label: "Assigned devices", value: "$assigned / $totalDevices"),
        const SizedBox(height: 18),

        SoftCard(
          onTap: app.logout,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: const Row(
            children: [
              Icon(Icons.logout_rounded),
              SizedBox(width: 10),
              Text("Logout", style: TextStyle(fontWeight: FontWeight.w900)),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return SoftCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: onSurface.withOpacity(0.65))),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }
}
