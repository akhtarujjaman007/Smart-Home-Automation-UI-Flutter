import 'package:flutter/material.dart';
import '../../core/app_controller.dart';
import '../../models/device.dart';
import 'panels/light_panel.dart';
import 'panels/router_panel.dart';
import 'panels/speaker_panel.dart';
import 'panels/thermostat_panel.dart';

class DeviceDetailPage extends StatelessWidget {
  final AppController app;
  final SmartDevice device;

  const DeviceDetailPage({super.key, required this.app, required this.device});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: app,
      builder: (_, __) {
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
                      Expanded(child: Text(device.name, style: Theme.of(context).textTheme.titleLarge)),
                      IconButton(
                        tooltip: "Unassign from room",
                        onPressed: device.roomId.isEmpty ? null : () => app.unassignDevice(device),
                        icon: const Icon(Icons.link_off_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: switch (device.type) {
                      DeviceType.light => LightPanel(app: app, d: device),
                      DeviceType.speaker => SpeakerPanel(app: app, d: device),
                      DeviceType.thermostat => ThermostatPanel(app: app, d: device),
                      DeviceType.router => RouterPanel(app: app, d: device),
                    },
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
