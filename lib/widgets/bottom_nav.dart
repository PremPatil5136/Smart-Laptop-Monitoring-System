import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    NotificationScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _BottomToggleNav(
        currentIndex: currentIndex,
        onChanged: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}

/* -------------------- GOOGLE STYLE TOGGLE NAV -------------------- */

class _BottomToggleNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const _BottomToggleNav({
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1D24),
        border: Border(
          top: BorderSide(color: Colors.white10),
        ),
      ),
      child: Stack(
        children: [
          // 🔹 Sliding indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            alignment: _indicatorAlignment(),
            child: Container(
              width: MediaQuery.of(context).size.width / 3,
              height: 3,
              color: Colors.deepPurpleAccent,
            ),
          ),

          // 🔹 Nav items
          Row(
            children: [
              _NavItem(
                icon: Icons.dashboard_outlined,
                label: "Home",
                selected: currentIndex == 0,
                onTap: () => onChanged(0),
              ),
              _NavItem(
                icon: Icons.notifications_none,
                label: "Alerts",
                selected: currentIndex == 1,
                onTap: () => onChanged(1),
              ),
              _NavItem(
                icon: Icons.person_outline,
                label: "Account",
                selected: currentIndex == 2,
                onTap: () => onChanged(2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Alignment _indicatorAlignment() {
    if (currentIndex == 0) return Alignment.bottomLeft;
    if (currentIndex == 1) return Alignment.bottomCenter;
    return Alignment.bottomRight;
  }
}

/* -------------------- NAV ITEM -------------------- */

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: selected ? Colors.white : Colors.white54,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: selected ? Colors.white : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
