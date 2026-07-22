import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmployeeDirectoryPage extends StatelessWidget {
  const EmployeeDirectoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Directory'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      backgroundColor: const Color(0xFF0F172A), // Dark background matching your theme
      // StreamBuilder listens to your Firestore database in real-time
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          // 1. If there's an error connecting to Firebase
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong connecting to the database.', style: TextStyle(color: Colors.white)),
            );
          }

          // 2. While waiting for data to load
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 3. If there is no data in the 'users' collection
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No employees found. Add some in Firebase!', style: TextStyle(color: Colors.white)),
            );
          }

          // 4. If we have data, show it in a list!
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              // Get the specific document (user)
              var document = snapshot.data!.docs[index];
              
              // Get the data fields inside the document
              var data = document.data() as Map<String, dynamic>;
              
              // Pull out the fields, providing fallbacks if they don't exist
              String name = data['name'] ?? 'Unknown Name';
              String jobTitle = data['job_title'] ?? 'No Title';
              String email = data['email'] ?? 'No Email';

              // Design the look of each employee in the list
              return Card(
                color: const Color(0xFF1E293B), // Card color matching your theme
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF6366F1), // Purple accent
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('$jobTitle\n$email', style: const TextStyle(color: Colors.white70)),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
