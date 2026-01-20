import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/alert_card.dart';
import '../widgets/severity_legend.dart';
import '../utils/constants.dart';
import '../widgets/empty_state.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1115),
      appBar: AppBar(
        title: const Text("Alerts & Notifications"),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('alerts')
            .where('uid', isEqualTo: uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const EmptyState();
          }

          final alerts = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SeverityLegend(),
              const SizedBox(height: 12),

              ...alerts.map((doc) {
                final data = doc.data() as Map<String, dynamic>;

                return AlertCard(
                  title: data['title'],
                  message: data['message'],
                  icon: _getIcon(data['severity']),
                  time: _timeAgo(data['createdAt']),
                  severity: _mapSeverity(data['severity']),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}

/* -------------------- HELPERS -------------------- */

AlertSeverity _mapSeverity(String severity) {
  switch (severity) {
    case 'critical':
      return AlertSeverity.critical;
    case 'warning':
      return AlertSeverity.warning;
    default:
      return AlertSeverity.info;
  }
}

IconData _getIcon(String severity) {
  switch (severity) {
    case 'critical':
      return Icons.error;
    case 'warning':
      return Icons.warning;
    default:
      return Icons.info;
  }
}

String _timeAgo(Timestamp timestamp) {
  final diff = DateTime.now().difference(timestamp.toDate());

  if (diff.inMinutes < 60) {
    return "${diff.inMinutes} min ago";
  } else if (diff.inHours < 24) {
    return "${diff.inHours} hr ago";
  } else {
    return "${diff.inDays} day ago";
  }
}









// import 'package:flutter/material.dart';
// // ignore: unused_import
// import '../widgets/alert_card.dart';
// // ignore: unused_import
// import '../widgets/severity_legend.dart';   
// // ignore: unused_import
// import '../utils/constants.dart';           
// // ignore: unused_import
// import '../widgets/empty_state.dart';


// class NotificationScreen extends StatelessWidget {
//   const NotificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0F1115),
//       appBar: AppBar(
//         title: const Text("Alerts & Notifications"),
//         backgroundColor: Colors.transparent,
//       ),

// //       body: ListView(
// //   padding: const EdgeInsets.all(16),
// //   children: const [

// //     SeverityLegend(),

// //     // 🟢 INFO
// //     AlertCard(
// //       title: "Charging Stopped",
// //       message: "Laptop is no longer charging.",
// //       icon: Icons.power_off,
// //       time: "10 min ago",
// //       severity: AlertSeverity.info,
// //     ),

// //     // 🟡 WARNING
// //     AlertCard(
// //       title: "Low Battery Warning",
// //       message: "Battery dropped below 20%. Plug in charger.",
// //       icon: Icons.battery_alert,
// //       time: "2 min ago",
// //       severity: AlertSeverity.warning,
// //     ),

// //     // 🔴 CRITICAL
// //     AlertCard(
// //       title: "System Update Available",
// //       message: "2 system updates are pending.",
// //       icon: Icons.system_update,
// //       time: "Yesterday",
// //       severity: AlertSeverity.critical,
// //     ),

// //     AlertCard(
// //       title: "Virus Definitions Outdated",
// //       message: "Antivirus database needs update.",
// //       icon: Icons.security,
// //       time: "1 hr ago",
// //       severity: AlertSeverity.warning,
// //     ),

// //     // 🟢 INFO
// //     AlertCard(
// //       title: "System Secure",
// //       message: "No threats detected. System running safe.",
// //       icon: Icons.verified_user,
// //       time: "Yesterday",
// //       severity: AlertSeverity.info,
// //     ),
// //   ],
// // ),

//     // Use when alerts list is empty
//       body: const EmptyState(),


//     );
//   }
// }
