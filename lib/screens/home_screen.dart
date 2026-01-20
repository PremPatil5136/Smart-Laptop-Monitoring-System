import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/glass_card.dart';
import '../widgets/status_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text("Smart Laptop Monitor"),
        backgroundColor: Colors.transparent,
        actions: [
          // Debug button to show UID
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Debug Info"),
                  content: SelectableText(
                    "Your UID:\n$uid\n\n"
                    "Backend should use:\nUSER_UID = \"$uid\"",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('battery_status')
            .doc(uid)
            .snapshots(),
        builder: (context, batterySnapshot) {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('system_status')
                .doc(uid)
                .snapshots(),
            builder: (context, systemSnapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('alerts')
                    .where('uid', isEqualTo: uid)
                    .orderBy('createdAt', descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (context, alertsSnapshot) {
                  // Debug: Check if data exists
                  final bool batteryExists = batterySnapshot.hasData && 
                      batterySnapshot.data!.exists;
                  final bool systemExists = systemSnapshot.hasData && 
                      systemSnapshot.data!.exists;

                  // Extract battery data
                  final batteryData = batterySnapshot.data?.data() as Map<String, dynamic>?;
                  final int batteryPercent = batteryData?['percentage'] ?? 0;
                  final bool charging = batteryData?['charging'] ?? false;
                  final String? timeLeft = batteryData?['time_left'];

                  // Extract system data
                  final systemData = systemSnapshot.data?.data() as Map<String, dynamic>?;
                  final double storageUsed = (systemData?['storage_used_gb'] ?? 0).toDouble();
                  final double storageTotal = (systemData?['storage_total_gb'] ?? 0).toDouble();
                  final int storagePercent = (systemData?['storage_usage_percent'] ?? 0).toInt();
                  final bool antivirusProtected = systemData?['antivirus_protected'] ?? false;
                  final int threats = systemData?['antivirus_threats'] ?? 0;
                  final bool updatesAvailable = systemData?['system_updates_available'] ?? false;
                  final double cpuUsage = (systemData?['cpu_usage_percent'] ?? 0).toDouble();
                  final double ramUsage = (systemData?['ram_usage_percent'] ?? 0).toDouble();

                  // Count alerts
                  final int alertCount = alertsSnapshot.data?.docs.length ?? 0;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Debug banner if no data
                        if (!batteryExists || !systemExists)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning, color: Colors.orange),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "No data from backend",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      Text(
                                        batteryExists 
                                            ? "Battery: ✓  System: ✗" 
                                            : "Battery: ✗  System: ${systemExists ? '✓' : '✗'}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        "Tap ℹ️ icon above to see your UID",
                                        style: TextStyle(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Status Banners - YOUR ORIGINAL COLORS
                        SizedBox(
                          height: 160,
                          child: PageView(
                            children: [
                              StatusBanner(
                                title: "Battery Charging",
                                subtitle: "$batteryPercent% • ${charging ? 'Plugged In' : 'On Battery'}",
                                icon: Icons.battery_charging_full,
                                color: Colors.deepPurpleAccent,  // Original color
                              ),
                              StatusBanner(
                                title: "System Security",
                                subtitle: antivirusProtected
                                    ? "No Threats Detected"
                                    : threats > 0
                                        ? "$threats Threat${threats > 1 ? 's' : ''} Found"
                                        : "Protection Disabled",
                                icon: Icons.security,
                                color: Colors.green,  // Original color
                              ),
                              StatusBanner(
                                title: updatesAvailable ? "Updates Available" : "System Up to Date",
                                subtitle: updatesAvailable
                                    ? "Updates Pending"
                                    : "All systems current",
                                icon: Icons.system_update,
                                color: Colors.orange,  // Original color
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Data Cards Grid - YOUR ORIGINAL COLORS
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          children: [
                            GlassCard(
                              title: "Battery",
                              value: "$batteryPercent%",
                              status: charging ? "Charging" : timeLeft ?? "On Battery",
                              icon: Icons.battery_full,
                              statusColor: const Color.fromARGB(255, 180, 195, 244),  // Original
                            ),
                            GlassCard(
                              title: "Storage",
                              value: storageTotal > 0 
                                  ? "${storageUsed.toStringAsFixed(1)} / ${storageTotal.toStringAsFixed(0)} GB"
                                  : "0.0 / 0 GB",
                              status: "$storagePercent% Used",
                              icon: Icons.sd_storage,
                              statusColor: const Color.fromARGB(255, 0, 26, 255),  // Original
                            ),
                            GlassCard(
                              title: "Antivirus",
                              value: antivirusProtected ? "Protected" : "At Risk",
                              status: threats > 0
                                  ? "$threats Threat${threats > 1 ? 's' : ''}"
                                  : antivirusProtected
                                      ? "No Threats"
                                      : "Disabled",
                              icon: Icons.verified_user,
                              statusColor: const Color.fromARGB(255, 2, 194, 247),  // Original
                            ),
                            GlassCard(
                              title: "System Updates",
                              value: updatesAvailable ? "Updates" : "Up to Date",
                              status: updatesAvailable
                                  ? "Action Required"
                                  : "All Current",
                              icon: Icons.system_update_alt,
                              statusColor: Colors.orange,  // Original
                            ),
                            GlassCard(
                              title: "Performance",
                              value: cpuUsage < 50 ? "Optimized" : "Busy",
                              status: "CPU: ${cpuUsage.toStringAsFixed(0)}% | RAM: ${ramUsage.toStringAsFixed(0)}%",
                              icon: Icons.speed,
                              statusColor: Colors.green,  // Original
                            ),
                            GlassCard(
                              title: "Alerts",
                              value: "$alertCount",
                              status: alertCount > 0 ? "View Details" : "All Clear",
                              icon: Icons.notifications_active,
                              statusColor: Colors.redAccent,  // Original
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}