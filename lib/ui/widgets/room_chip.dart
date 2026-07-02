import 'package:flutter/material.dart';
import 'soft_card.dart';

class RoomChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const RoomChip({super.key, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      pressed: selected,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      borderRadius: BorderRadius.circular(14),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_view_rounded, size: 18, color: selected ? Colors.blueAccent : Theme.of(context).iconTheme.color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
