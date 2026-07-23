import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications', style: TextStyle(color: Colors.white)),
        backgroundColor: bgCard,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: bgDark,
      body: StreamBuilder<QuerySnapshot>(
        // Listen to the 'notifications' collection, ordered by newest first
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading notifications', style: TextStyle(color: Colors.white)));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'You have no new notifications.\nGo to Firebase to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;

              String title = data['title'] ?? 'Alert';
              String message = data['message'] ?? '';
              bool isRead = data['isRead'] ?? false;
              
              // Formatting the timestamp safely
              String timeString = 'Just now';
              if (data['timestamp'] != null && data['timestamp'] is Timestamp) {
                DateTime dt = (data['timestamp'] as Timestamp).toDate();
                timeString = "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
              }

              return Card(
                color: bgCard,
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: primaryColor.withValues(alpha: 0.1),
                    child: Icon(
                      Icons.notifications,
                      color: isRead ? Colors.grey : primaryColor,
                    ),
                  ),
                  title: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(message, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text(timeString, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    // Mark as read when tapped
                    if (!isRead) {
                      FirebaseFirestore.instance.collection('notifications').doc(doc.id).update({'isRead': true});
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
