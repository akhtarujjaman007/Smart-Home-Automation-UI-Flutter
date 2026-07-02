import 'package:flutter/material.dart';
import '../../models/device.dart';
import 'soft_card.dart';

class DeviceCard extends StatelessWidget {
  final SmartDevice device;
  final VoidCallback onTap;

  const DeviceCard({super.key, required this.device, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final isSpeaker = device.type == DeviceType.speaker;

    final tileBg = isSpeaker
        ? (isDarkTheme ? const Color(0xFF0F1012) : const Color(0xFF0E0E0E))
        : (isDarkTheme ? const Color(0xFF1A1C20) : const Color(0xFFF4F6F6));

    final onSurface = Theme.of(context).colorScheme.onSurface;
    final textColor = isSpeaker ? Colors.white : onSurface;
    final subTextColor = isSpeaker ? Colors.white70 : onSurface.withOpacity(0.65);

    return SoftCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Container(
        decoration: BoxDecoration(
          color: tileBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDarkTheme ? Colors.white.withOpacity(.06) : Colors.black.withOpacity(.03),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(
                device.isOn ? Icons.toggle_on_rounded : Icons.toggle_off_rounded,
                color: device.isOn ? Colors.blueAccent : subTextColor,
                size: 34,
              ),
            ),
            const Spacer(),
            Icon(device.icon, size: 32, color: textColor),
            const SizedBox(height: 10),
            Text(device.name, style: TextStyle(fontWeight: FontWeight.w900, color: textColor)),
            const SizedBox(height: 6),
            Text(device.valueLabel, style: TextStyle(fontWeight: FontWeight.w800, color: subTextColor)),
          ],
        ),
      ),
    );
  }
}
