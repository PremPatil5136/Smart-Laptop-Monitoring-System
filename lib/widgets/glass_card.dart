import 'package:flutter/material.dart';

class GlassCard extends StatefulWidget {
  final String title;
  final String value;
  final String status;
  final IconData icon;
  final Color statusColor;

  const GlassCard({
    super.key,
    required this.title,
    required this.value,
    required this.status,
    required this.icon,
    required this.statusColor,
  });

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.translationValues(0, _pressed ? -6 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: _pressed ? 16 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.icon, size: 44, color: widget.statusColor),
              const Spacer(),
              Text(widget.title,
                  style:
                      const TextStyle(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 6),
              Text(widget.value,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(widget.status,
                  style:
                      const TextStyle(fontSize: 12, color: Colors.white54)),
            ],
          ),
        ),
      ),
    );
  }
}
