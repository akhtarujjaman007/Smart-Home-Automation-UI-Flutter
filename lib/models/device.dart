import 'package:flutter/material.dart';

enum DeviceType { speaker, thermostat, light, router }

class SmartDevice {
  final String id;
  final String name;
  final DeviceType type;

  bool isOn;
  String roomId; // "" = unassigned

  // Light
  double brightness; // 0..1
  double intensity; // 0..1

  // Speaker
  double volume; // 0..1
  bool playing;

  // Thermostat
  double temperature; // 10..35
  String thermoMode; // Auto/Cool/Heat

  // Router
  int wifiStrength; // 0..100
  int speedMbps;

  SmartDevice({
    required this.id,
    required this.name,
    required this.type,
    this.isOn = true,
    this.roomId = "",
    this.brightness = 0.5,
    this.intensity = 0.7,
    this.volume = 0.6,
    this.playing = true,
    this.temperature = 25.0,
    this.thermoMode = "Auto",
    this.wifiStrength = 85,
    this.speedMbps = 200,
  });

  IconData get icon {
    switch (type) {
      case DeviceType.speaker:
        return Icons.speaker_rounded;
      case DeviceType.thermostat:
        return Icons.thermostat_rounded;
      case DeviceType.light:
        return Icons.lightbulb_rounded;
      case DeviceType.router:
        return Icons.router_rounded;
    }
  }

  String get valueLabel {
    switch (type) {
      case DeviceType.speaker:
        return "${(volume * 100).round()}%";
      case DeviceType.light:
        return "${(brightness * 100).round()}%";
      case DeviceType.thermostat:
        return "${temperature.toStringAsFixed(0)}°C";
      case DeviceType.router:
        return "$speedMbps mbps";
    }
  }
}
