import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'theme.dart';

class TasksBoardPage extends StatefulWidget {
  final String uid;
  const TasksBoardPage({super.key, required this.uid});

  @override
  State<TasksBoardPage> createState() => _TasksBoardPageState();
}

class _TasksBoardPageState extends State<TasksBoardPage> {
  Stream<QuerySnapshot>? _tasksStream;

  @override
  void initState() {
    super.initState();
    _tasksStream = FirebaseFirestore.instance
        .collection('tasks')
        .where('userId', isEqualTo: widget.uid)
        .snapshots();
    _seedTasksIfNeeded(widget.uid);
  }

  Future<void> _seedTasksIfNeeded(String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: uid)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        final tasksRef = FirebaseFirestore.instance.collection('tasks');
        
        batch.set(tasksRef.doc(), {
          'userId': uid,
          'title': 'Deploy API to Kubernetes cluster',
          'description': 'Deploy the node.js microservice API deployment and service to the local K8s cluster.',
          'status': 'todo',
          'priority': 'high',
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        batch.set(tasksRef.doc(), {
          'userId': uid,
          'title': 'Refactor Firestore Auth rules',
          'description': 'Update firestore.rules to secure collections by checking request.auth.uid.',
          'status': 'in_progress',
          'priority': 'medium',
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        batch.set(tasksRef.doc(), {
          'userId': uid,
          'title': 'Design modern dark theme layout',
          'description': 'Create beautiful radial gradients and typography layout for the landing dashboard.',
          'status': 'done',
          'priority': 'low',
          'createdAt': FieldValue.serverTimestamp(),
        });

        await batch.commit();
      }
    } catch (e) {
      debugPrint("Error seeding tasks: $e");
    }
  }

  Future<void> _updateTaskStatus(String docId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(docId).update({
        'status': newStatus,
      });
    } catch (e) {
      debugPrint("Error updating task status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.7, -0.6),
            radius: 1.2,
            colors: [
              Color(0xFF1E1E38),
              bgDark,
            ],
          ),
        ),
        child: Column(
          children: [
            // Glassmorphic Top Navbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: bgDark.withOpacity(0.8),
                border: const Border(
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Back Button
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: textMain),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  // Logo
                  Text(
                    "InetHRM",
                    style: GoogleFonts.outfit(
                      color: textMain,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: primaryColor, width: 0.5),
                    ),
                    child: Text(
                      "v1.0",
                      style: GoogleFonts.outfit(
                        color: primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    "Developer Portal",
                    style: GoogleFonts.outfit(
                      color: textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Content Header
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Developer Tasks Board",
                        style: GoogleFonts.outfit(
                          color: textMain,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Manage developer tasks and project status.",
                        style: GoogleFonts.outfit(
                          color: textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Kanban columns
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _tasksStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: GoogleFonts.outfit(color: dangerColor),
                      ),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    );
                  }

                  final docs = snapshot.data?.docs ?? [];
                  
                  final todoTasks = docs.where((doc) => doc['status'] == 'todo').toList();
                  final inProgressTasks = docs.where((doc) => doc['status'] == 'in_progress').toList();
                  final doneTasks = docs.where((doc) => doc['status'] == 'done').toList();

                  void sortTasks(List<QueryDocumentSnapshot> list) {
                    list.sort((a, b) {
                      final aTime = (a.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
                      final bTime = (b.data() as Map<String, dynamic>)['createdAt'] as Timestamp?;
                      if (aTime == null) return 1;
                      if (bTime == null) return -1;
                      return bTime.compareTo(aTime);
                    });
                  }
                  sortTasks(todoTasks);
                  sortTasks(inProgressTasks);
                  sortTasks(doneTasks);

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildKanbanColumn("To Do", todoTasks, 'todo', accentColor),
                          const SizedBox(width: 24),
                          _buildKanbanColumn("In Progress", inProgressTasks, 'in_progress', warningColor),
                          const SizedBox(width: 24),
                          _buildKanbanColumn("Completed", doneTasks, 'done', successColor),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildKanbanColumn(String title, List<QueryDocumentSnapshot> tasks, String columnStatus, Color headerColor) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: bgCard.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Column Header
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: headerColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: textMain,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: borderColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tasks.length.toString(),
                  style: GoogleFonts.outfit(
                    color: textMain,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Tasks list
          if (tasks.isEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Text(
                "No tasks in this column",
                style: GoogleFonts.outfit(
                  color: textMuted,
                  fontSize: 13,
                ),
              ),
            )
          else
            Container(
              constraints: const BoxConstraints(maxHeight: 500),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  final data = task.data() as Map<String, dynamic>;
                  final docId = task.id;
                  final taskTitle = data['title'] ?? 'Untitled';
                  final desc = data['description'] ?? '';
                  final priority = data['priority'] ?? 'low';

                  Color pBg;
                  Color pTxt;
                  if (priority == 'high') {
                    pBg = dangerColor.withOpacity(0.15);
                    pTxt = dangerColor;
                  } else if (priority == 'medium') {
                    pBg = warningColor.withOpacity(0.15);
                    pTxt = warningColor;
                  } else {
                    pBg = primaryColor.withOpacity(0.15);
                    pTxt = primaryColor;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgDarker,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderColor, width: 1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: pBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                priority.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  color: pTxt,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          taskTitle,
                          style: GoogleFonts.outfit(
                            color: textMain,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          desc,
                          style: GoogleFonts.outfit(
                            color: textMuted,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (columnStatus != 'todo')
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: bgCard,
                                  foregroundColor: textMain,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    side: const BorderSide(color: borderColor),
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_back, size: 12),
                                label: Text(
                                  columnStatus == 'done' ? "Reopen" : "To Do",
                                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  final newStatus = columnStatus == 'done' ? 'in_progress' : 'todo';
                                  _updateTaskStatus(docId, newStatus);
                                },
                              ),
                            if (columnStatus != 'todo') const SizedBox(width: 8),
                            if (columnStatus != 'done')
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: bgDarker,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                icon: const Icon(Icons.arrow_forward, size: 12),
                                label: Text(
                                  columnStatus == 'todo' ? "Start" : "Complete",
                                  style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  final newStatus = columnStatus == 'todo' ? 'in_progress' : 'done';
                                  _updateTaskStatus(docId, newStatus);
                                },
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
