import 'package:flutter/material.dart';

class SeverityLegend extends StatelessWidget {
  const SeverityLegend({super.key});

  void _showLegend(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1D24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _LegendSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _Dot(color: Colors.green),
          const Text(" Info", style: TextStyle(color: Colors.white70)),
          const SizedBox(width: 14),

          _Dot(color: Colors.orange),
          const Text(" Warning", style: TextStyle(color: Colors.white70)),
          const SizedBox(width: 14),

          _Dot(color: Colors.redAccent),
          const Text(" Critical", style: TextStyle(color: Colors.white70)),

          const Spacer(),

          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white54),
            onPressed: () => _showLegend(context),
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/* -------------------- BOTTOM SHEET -------------------- */

class _LegendSheet extends StatelessWidget {
  const _LegendSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Alert Severity",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),

          _LegendRow(
            color: Colors.green,
            title: "Info",
            desc: "System normal. No action needed.",
          ),
          SizedBox(height: 12),

          _LegendRow(
            color: Colors.orange,
            title: "Warning",
            desc: "Attention required. Action recommended.",
          ),
          SizedBox(height: 12),

          _LegendRow(
            color: Colors.redAccent,
            title: "Critical",
            desc: "Immediate action required.",
          ),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String title;
  final String desc;

  const _LegendRow({
    required this.color,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                desc,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
