import 'package:flutter/material.dart';
import '../../core/app_controller.dart';
import '../../models/session.dart';
import '../map/device_mapping_page.dart';
import '../profile/profile_page.dart';
import '../rooms/rooms_dashboard.dart';
import '../widgets/soft_card.dart';

class MainShell extends StatefulWidget {
  final AppController app;
  final bool isDark;
  final VoidCallback onToggleTheme;

  const MainShell({
    super.key,
    required this.app,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int tab = 0; // 0 rooms, 1 map, 2 profile

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.app,
      builder: (_, __) {
        final UserSession session = widget.app.session!;
        final pages = [
          RoomsDashboard(app: widget.app),
          DeviceMappingPage(app: widget.app),
          ProfilePage(app: widget.app, session: session),
        ];

        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              child: Column(
                children: [
                  _TopBar(
                    title: tab == 0 ? "Smart Home" : (tab == 1 ? "Device Mapping" : "Profile"),
                    subtitle: "Hi ${session.name}",
                    isDark: widget.isDark,
                    onToggleTheme: widget.onToggleTheme,
                    onLogout: widget.app.logout,
                    onAddRoom: tab == 0 ? () => _showAddRoomDialog(context) : null,
                  ),
                  const SizedBox(height: 10),
                  Expanded(child: pages[tab]),
                  const SizedBox(height: 10),
                  _BottomNav(
                    index: tab,
                    onChanged: (i) => setState(() => tab = i),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddRoomDialog(BuildContext context) async {
    final c = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create new room"),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(hintText: "Room name (e.g., Office)"),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text("Create")),
        ],
      ),
    );

    if (ok == true) widget.app.addRoom(c.text);
  }
}

class _TopBar extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;
  final VoidCallback? onAddRoom;

  const _TopBar({
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onToggleTheme,
    required this.onLogout,
    this.onAddRoom,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Row(
      children: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.menu_rounded)),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: t.titleLarge),
              Text(subtitle, style: t.bodyMedium?.copyWith(color: onSurface.withOpacity(0.7))),
            ],
          ),
        ),
        if (onAddRoom != null)
          IconButton(onPressed: onAddRoom, icon: const Icon(Icons.add_circle_outline_rounded)),
        IconButton(
          onPressed: onToggleTheme,
          icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
        ),
        PopupMenuButton<String>(
          icon: const CircleAvatar(radius: 16, child: Icon(Icons.person)),
          onSelected: (v) {
            if (v == "logout") onLogout();
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: "logout", child: Text("Logout")),
          ],
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _BottomNav({required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      borderRadius: BorderRadius.circular(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(selected: index == 0, icon: Icons.dashboard_rounded, label: "Rooms", onTap: () => onChanged(0)),
          _NavItem(selected: index == 1, icon: Icons.device_hub_rounded, label: "Map", onTap: () => onChanged(1)),
          _NavItem(selected: index == 2, icon: Icons.person_rounded, label: "Profile", onTap: () => onChanged(2)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.selected, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = selected ? Colors.blueAccent : Theme.of(context).colorScheme.onSurface.withOpacity(0.75);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
          ],
        ),
      ),
    );
  }
}
