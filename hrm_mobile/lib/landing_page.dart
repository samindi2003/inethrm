import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tasks_board_page.dart';

// Styling Colors matching index.html variables
const Color bgDark = Color(0xFF0F172A);
const Color bgDarker = Color(0xFF090D16);
const Color bgCard = Color(0xFF1E293B);
const Color primaryColor = Color(0xFF6366F1);
const Color primaryHover = Color(0xFF4F46E5);
const Color accentColor = Color(0xFF06B6D4);
const Color textMain = Color(0xFFF8FAFC);
const Color textMuted = Color(0xFF94A3B8);
const Color borderColor = Color(0xFF334155);
const Color successColor = Color(0xFF10B981);
const Color warningColor = Color(0xFFF59E0B);
const Color dangerColor = Color(0xFFEF4444);

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _demoKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 968;

    return Scaffold(
      backgroundColor: bgDark,
      body: Stack(
        children: [
          // Background Blobs
          Positioned(
            top: -150,
            left: -150,
            child: _buildBlob(accentColor.withValues(alpha: 0.15)),
          ),
          Positioned(
            top: 700,
            right: -150,
            child: _buildBlob(primaryColor.withValues(alpha: 0.12)),
          ),

          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                // Top margin to prevent content being hidden under sticky navbar
                const SizedBox(height: 90),

                // Hero Section
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 60.0 : 20.0,
                    vertical: 40.0,
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _buildHeroContent(isDesktop),
                                ),
                                const SizedBox(width: 60),
                                Expanded(
                                  key: _demoKey,
                                  flex: 5,
                                  child: const PortalMockup(),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildHeroContent(isDesktop),
                                const SizedBox(height: 50),
                                PortalMockup(key: _demoKey),
                              ],
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Features Section
                Container(
                  key: _featuresKey,
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? 60.0 : 20.0,
                    vertical: 60.0,
                  ),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        children: [
                          Text(
                            "Why InetHRM?",
                            style: GoogleFonts.outfit(
                              fontSize: isDesktop ? 36 : 28,
                              fontWeight: FontWeight.bold,
                              color: textMain,
                            ),
                          ),
                          const SizedBox(height: 50),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (constraints.maxWidth > 800) {
                                return GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 30,
                                  mainAxisSpacing: 30,
                                  childAspectRatio: 1.8,
                                  children: _buildFeatures(),
                                );
                              } else {
                                return ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: _buildFeatures()
                                      .map((card) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20.0),
                                            child: card,
                                          ))
                                      .toList(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Footer
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: borderColor, width: 1),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Center(
                    child: Text(
                      "© 2026 InetHRM. Built with Node.js, Express, React, PostgreSQL, and Kubernetes.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: textMuted,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sticky Sticky Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildNavbar(isDesktop),
          ),
        ],
      ),
    );
  }

  // Radial Gradient Blur Background Blob
  Widget _buildBlob(Color color) {
    return Container(
      width: 500,
      height: 500,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 0.7],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  // Navbar Widget
  Widget _buildNavbar(bool isDesktop) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: bgDark.withValues(alpha: 0.7),
            border: const Border(
              bottom: BorderSide(color: borderColor, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo
                  Row(
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.white, accentColor],
                        ).createShader(bounds),
                        child: Text(
                          "InetHRM",
                          style: GoogleFonts.outfit(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "V1.0",
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Nav Links & Actions
                  if (isDesktop)
                    Row(
                      children: [
                        _NavbarLink(
                          text: "Features",
                          onTap: () => _scrollTo(_featuresKey),
                        ),
                        const SizedBox(width: 30),
                        _NavbarLink(
                          text: "Try Demo",
                          onTap: () => _scrollTo(_demoKey),
                        ),
                        const SizedBox(width: 30),
                        _HoverButton(
                          text: "Portal Login",
                          onPressed: () => _scrollTo(_demoKey),
                          isPrimary: true,
                        ),
                      ],
                    )
                  else
                    // Simple text actions for mobile to save space
                    Row(
                      children: [
                        _NavbarLink(
                          text: "Demo",
                          onTap: () => _scrollTo(_demoKey),
                        ),
                        const SizedBox(width: 15),
                        _HoverButton(
                          text: "Login",
                          onPressed: () => _scrollTo(_demoKey),
                          isPrimary: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hero Content Widget
  Widget _buildHeroContent(bool isDesktop) {
    final align = isDesktop ? TextAlign.left : TextAlign.center;
    return Column(
      crossAxisAlignment:
          isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFA5B4FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            "Modern HR\nManagement,\nScaled on Kubernetes",
            textAlign: align,
            style: GoogleFonts.outfit(
              fontSize: isDesktop ? 54 : 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.15,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Text(
            "A full-featured HRM system designed with a secure Node.js backend, robust PostgreSQL database, and a smooth, modern React frontend interface.",
            textAlign: align,
            style: GoogleFonts.outfit(
              color: textMuted,
              fontSize: 18,
              height: 1.5,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment:
              isDesktop ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: [
            _HoverButton(
              text: "Launch Portal Demo",
              onPressed: () => _scrollTo(_demoKey),
              isPrimary: true,
            ),
            const SizedBox(width: 16),
            _HoverButton(
              text: "Explore Features",
              onPressed: () => _scrollTo(_featuresKey),
              isPrimary: false,
            ),
          ],
        ),
      ],
    );
  }

  // Feature Cards Generator
  List<Widget> _buildFeatures() {
    return const [
      _FeatureCard(
        icon: "👤",
        title: "Employee Profiles",
        description:
            "Manage employee records, job positions, and roles securely in a centralized Postgres database.",
      ),
      _FeatureCard(
        icon: "⏰",
        title: "Attendance & Shift Logs",
        description:
            "Simple clock-in / clock-out interface with geolocation tracking and status tags.",
      ),
      _FeatureCard(
        icon: "📄",
        title: "Leave Requests",
        description:
            "Submit leave applications and route approvals directly through dynamic HR dashboards.",
      ),
      _FeatureCard(
        icon: "☸️",
        title: "Kubernetes Deployment",
        description:
            "Full deployment pipeline blueprints to run database, API server, and web frontend in local/cloud K8s clusters.",
      ),
    ];
  }
}

// Navigation Bar Link
class _NavbarLink extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _NavbarLink({required this.text, required this.onTap});

  @override
  State<_NavbarLink> createState() => _NavbarLinkState();
}

class _NavbarLinkState extends State<_NavbarLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          style: GoogleFonts.outfit(
            color: _isHovered ? textMain : textMuted,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// Custom Hoverable Button
class _HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isPrimary;
  final EdgeInsetsGeometry? padding;

  const _HoverButton({
    required this.text,
    required this.onPressed,
    required this.isPrimary,
    this.padding,
  });

  @override
  State<_HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<_HoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final defaultPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 14);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
          padding: widget.padding ?? defaultPadding,
          decoration: BoxDecoration(
            gradient: widget.isPrimary
                ? const LinearGradient(
                    colors: [primaryColor, primaryHover],
                  )
                : null,
            color: widget.isPrimary
                ? null
                : (_isHovered ? borderColor : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: widget.isPrimary
                ? null
                : Border.all(color: borderColor, width: 1),
            boxShadow: widget.isPrimary && _isHovered
                ? [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.6),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    )
                  ]
                : (widget.isPrimary
                    ? [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.4),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        )
                      ]
                    : []),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.outfit(
              color: textMain,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// Hoverable Feature Card
class _FeatureCard extends StatefulWidget {
  final String icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        transform:
            Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? accentColor : borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: _isHovered ? 0.1 : 0),
              blurRadius: 25,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withValues(alpha: 0.2),
                    accentColor.withValues(alpha: 0.2),
                  ],
                ),
              ),
              child: Center(
                child: Text(
                  widget.icon,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.title,
              style: GoogleFonts.outfit(
                color: textMain,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.description,
              style: GoogleFonts.outfit(
                color: textMuted,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Portal Mockup Widget
class PortalMockup extends StatefulWidget {
  const PortalMockup({super.key});

  @override
  State<PortalMockup> createState() => _PortalMockupState();
}

class _PortalMockupState extends State<PortalMockup> {
  bool _isLoggedIn = false;
  bool _isRegistering = false;
  bool _showHistory = false;
  bool _showLeaves = false;
  bool _showTasks = false;
  bool _isApplyingLeave = true;
  bool _isLoading = false;
  String _errorMessage = '';
  Stream<QuerySnapshot>? _historyStream;
  Stream<QuerySnapshot>? _leavesStream;
  Stream<QuerySnapshot>? _tasksStream;

  // Leave Form Fields
  String _selectedLeaveType = 'Annual';
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _leaveReasonController = TextEditingController();

  // Controllers
  final TextEditingController _emailController = TextEditingController(text: "junior.developer@inethrm.com");
  final TextEditingController _passwordController = TextEditingController(text: "password123");
  final TextEditingController _nameController = TextEditingController();

  // User details fetched from Firestore
  String _userName = 'Junior Developer';
  String _userRole = 'Engineering Dept.';
  int _leavesLeft = 14;
  double _attendanceRate = 98.5;

  // Timer Variables
  Timer? _timer;
  int _seconds = 28800; // 8 hours
  bool _isClockedIn = true;

  @override
  void initState() {
    super.initState();
    // Check if user is already logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _loadUserProfile(user.uid);
    }
  }

  Future<void> _loadUserProfile(String uid) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _historyStream = FirebaseFirestore.instance
          .collection('attendance_logs')
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
      _leavesStream = FirebaseFirestore.instance
          .collection('leave_requests')
          .where('userId', isEqualTo: uid)
          .snapshots();
      _tasksStream = FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: uid)
          .snapshots();
    });
    try {
      await _seedTasksIfNeeded(uid);
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _userName = data['name'] ?? 'User';
          _userRole = data['role'] ?? 'Junior Developer';
          _leavesLeft = data['leavesLeft'] ?? 14;
          _attendanceRate = (data['attendanceRate'] as num?)?.toDouble() ?? 98.5;
          _isLoggedIn = true;
        });
      } else {
        setState(() {
          _userName = 'User';
          _isLoggedIn = true;
        });
      }
      _startTimer();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final credentials = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final uid = credentials.user!.uid;

      _historyStream = FirebaseFirestore.instance
          .collection('attendance_logs')
          .where('userId', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .snapshots();
      _leavesStream = FirebaseFirestore.instance
          .collection('leave_requests')
          .where('userId', isEqualTo: uid)
          .snapshots();
      _tasksStream = FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: uid)
          .snapshots();

      await _seedTasksIfNeeded(uid);

      // Save user details in Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'Junior Developer',
        'department': 'Engineering Dept.',
        'leavesLeft': 14,
        'attendanceRate': 100.0,
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _userName = _nameController.text.trim();
        _userRole = 'Engineering Dept.';
        _leavesLeft = 14;
        _attendanceRate = 100.0;
        _isLoggedIn = true;
      });
      _startTimer();
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException in Register: [${e.code}] ${e.message}");
      setState(() {
        _errorMessage = e.message ?? 'An error occurred: [${e.code}]';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save profile: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Email and Password are required';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _loadUserProfile(credentials.user!.uid);
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException in Login: [${e.code}] ${e.message}");
      setState(() {
        _errorMessage = e.message ?? 'An error occurred: [${e.code}]';
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

    Future<void> _handleLogout() async {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signOut();
        _stopTimer();
        setState(() {
          _isLoggedIn = false;
          _showHistory = false;
          _showLeaves = false;
          _showTasks = false;
          _isApplyingLeave = true;
          _historyStream = null;
          _leavesStream = null;
          _tasksStream = null;
          _startDate = null;
          _endDate = null;
          _leaveReasonController.clear();
          _nameController.clear();
          _errorMessage = '';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to log out: $e';
        });
      } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logAttendance(String action) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('attendance_logs').add({
          'userId': user.uid,
          'timestamp': FieldValue.serverTimestamp(),
          'action': action,
        });
      } catch (e) {
        debugPrint("Failed to log attendance: $e");
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _toggleClock() {
    setState(() {
      if (_isClockedIn) {
        _stopTimer();
        _isClockedIn = false;
        _logAttendance('clock_out');
      } else {
        _startTimer();
        _isClockedIn = true;
        _logAttendance('clock_in');
      }
    });
  }

  String _formatTime(int totalSecs) {
    final hrs = (totalSecs ~/ 3600).toString().padLeft(2, '0');
    final mins = ((totalSecs % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSecs % 60).toString().padLeft(2, '0');
    return "$hrs:$mins:$secs";
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'JD';
    final parts = name.trim().split(' ');
    if (parts.length > 1) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _leaveReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 40,
            offset: Offset(0, 20),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Top Accent Line
            Container(
              height: 3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, accentColor],
                ),
              ),
            ),

            // Window Header
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Windows dots
                  Row(
                    children: [
                      _buildDot(dangerColor),
                      const SizedBox(width: 6),
                      _buildDot(warningColor),
                      const SizedBox(width: 6),
                      _buildDot(successColor),
                    ],
                  ),
                  Text(
                    "inethrm-portal-v1.local",
                    style: GoogleFonts.outfit(
                      color: textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 36), // Balanced spacing
                ],
              ),
            ),
            const Divider(color: borderColor, height: 1),

            // Body Area (Login OR Dashboard OR Shift History OR Leaves Manager)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: !_isLoggedIn
                  ? KeyedSubtree(key: const ValueKey('login'), child: _buildLoginForm())
                  : _showLeaves
                      ? KeyedSubtree(key: const ValueKey('leaves'), child: _buildLeaveManagement())
                      : _showTasks
                          ? KeyedSubtree(key: const ValueKey('tasks'), child: _buildTasksBoard())
                          : _showHistory
                              ? KeyedSubtree(key: const ValueKey('history'), child: _buildShiftHistory())
                              : KeyedSubtree(key: const ValueKey('dashboard'), child: _buildDashboard()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  // State 1: Login/Register Form
  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isRegistering ? "Portal Registration" : "Portal Login",
            style: GoogleFonts.outfit(
              color: textMain,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _isRegistering
                ? "Create a new developer account to access the system."
                : "Sign in using your developer credentials.",
            style: GoogleFonts.outfit(
              color: textMuted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),

          // Error Message Display
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                _errorMessage,
                style: GoogleFonts.outfit(
                  color: dangerColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Name (only on registration)
          if (_isRegistering) ...[
            _buildTextField("Full Name", _nameController),
            const SizedBox(height: 16),
          ],

          // Email
          _buildTextField("Email Address", _emailController),
          const SizedBox(height: 16),

          // Password
          _buildTextField("Password", _passwordController, obscure: true),
          const SizedBox(height: 24),

          // Submit Button
          GestureDetector(
            onTap: _isLoading
                ? null
                : (_isRegistering ? _handleRegister : _handleLogin),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, primaryHover],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _isRegistering ? "Create Developer Account" : "Sign In as Developer",
                      style: GoogleFonts.outfit(
                        color: textMain,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          // Toggle Login/Register
          Center(
            child: TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      setState(() {
                        _isRegistering = !_isRegistering;
                        _errorMessage = '';
                      });
                    },
              child: Text(
                _isRegistering
                    ? "Already have an account? Sign In"
                    : "Don't have an account? Register",
                style: GoogleFonts.outfit(
                  color: accentColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: bgDark,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            cursorColor: accentColor,
            style: GoogleFonts.outfit(
              color: textMain,
              fontSize: 15,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  // State 2: Dashboard View
  Widget _buildDashboard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primaryColor, accentColor],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(_userName),
                        style: GoogleFonts.outfit(
                          color: textMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userName,
                        style: GoogleFonts.outfit(
                          color: textMain,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        _userRole,
                        style: GoogleFonts.outfit(
                          color: textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Active Session",
                      style: GoogleFonts.outfit(
                        color: successColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _isLoading ? null : _handleLogout,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: dangerColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.logout,
                        size: 16,
                        color: dangerColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard("Leaves Left", "$_leavesLeft Days"),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard("Attendance Rate", "$_attendanceRate%"),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Clock Widget
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withValues(alpha: 0.1),
                  accentColor.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Column(
              children: [
                Text(
                  "Shift Tracker",
                  style: GoogleFonts.outfit(
                    color: textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, accentColor],
                  ).createShader(bounds),
                  child: Text(
                    _formatTime(_seconds),
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                MouseRegion(
                  child: GestureDetector(
                    onTap: _toggleClock,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: _isClockedIn
                            ? const LinearGradient(
                                colors: [primaryColor, primaryHover],
                              )
                            : const LinearGradient(
                                colors: [successColor, Color(0xFF059669)],
                              ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _isClockedIn ? "Clock Out" : "Clock In",
                        style: GoogleFonts.outfit(
                          color: textMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.history, size: 15, color: accentColor),
                      label: Text(
                        "History",
                        style: GoogleFonts.outfit(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _showHistory = true;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.work_off, size: 15, color: accentColor),
                      label: Text(
                        "Leaves",
                        style: GoogleFonts.outfit(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _showLeaves = true;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.assignment, size: 15, color: accentColor),
                      label: Text(
                        "Tasks",
                        style: GoogleFonts.outfit(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _showTasks = true;
                        });
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          _seedTasksIfNeeded(user.uid);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String val) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgDark,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: GoogleFonts.outfit(
              color: textMuted,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: GoogleFonts.outfit(
              color: textMain,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Leave Management Screen View
  Widget _buildLeaveManagement() {
    if (_leavesStream == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Back Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showLeaves = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: borderColor.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 16,
                        color: textMain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Leave Manager",
                    style: GoogleFonts.outfit(
                      color: textMain,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Segmented Tab Controls
          Row(
            children: [
              Expanded(
                child: _buildTabButton("Apply Leave", _isApplyingLeave, () {
                  setState(() {
                    _isApplyingLeave = true;
                    _errorMessage = '';
                  });
                }),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTabButton("My Requests", !_isApplyingLeave, () {
                  setState(() {
                    _isApplyingLeave = false;
                    _errorMessage = '';
                  });
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Tab Body
          SizedBox(
            height: 280,
            child: _isApplyingLeave ? _buildApplyLeaveForm() : _buildMyLeavesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? primaryColor.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: active ? primaryColor : borderColor,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            color: active ? primaryColor : textMuted,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildApplyLeaveForm() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Error Display
          if (_errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                _errorMessage,
                style: GoogleFonts.outfit(
                  color: dangerColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Leave Type Cards Row
          Text(
            "Leave Type",
            style: GoogleFonts.outfit(color: textMuted, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Row(
            children: ['Annual', 'Sick', 'Casual'].map((type) {
              final isSelected = _selectedLeaveType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedLeaveType = type;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : bgDark,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? primaryColor : borderColor,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      type,
                      style: GoogleFonts.outfit(
                        color: textMain,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Dates Selection
          Row(
            children: [
              Expanded(
                child: _buildDatePickerTile(
                  "Start Date",
                  _startDate,
                  (date) => setState(() => _startDate = date),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDatePickerTile(
                  "End Date",
                  _endDate,
                  (date) => setState(() => _endDate = date),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Reason TextField
          Text(
            "Reason",
            style: GoogleFonts.outfit(color: textMuted, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              color: bgDark,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: TextField(
              controller: _leaveReasonController,
              maxLines: 2,
              cursorColor: accentColor,
              style: GoogleFonts.outfit(color: textMain, fontSize: 14),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter the reason for leave...",
                hintStyle: GoogleFonts.outfit(color: textMuted.withValues(alpha: 0.5), fontSize: 13),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Submit Button
          GestureDetector(
            onTap: _isLoading ? null : _submitLeaveRequest,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryColor, primaryHover],
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textMain),
                      ),
                    )
                  : Text(
                      "Submit Leave Request",
                      style: GoogleFonts.outfit(
                        color: textMain,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerTile(String label, DateTime? date, Function(DateTime) onSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: textMuted, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final selected = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: primaryColor,
                      onPrimary: textMain,
                      surface: bgCard,
                      onSurface: textMain,
                    ),
                    dialogBackgroundColor: bgCard,
                  ),
                  child: child!,
                );
              },
            );
            if (selected != null) {
              onSelected(selected);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bgDark,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date == null ? "Select Date" : "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                  style: GoogleFonts.outfit(
                    color: date == null ? textMuted : textMain,
                    fontSize: 13,
                  ),
                ),
                const Icon(Icons.calendar_today, size: 14, color: textMuted),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMyLeavesList() {
    return StreamBuilder<QuerySnapshot>(
      stream: _leavesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading leaves: ${snapshot.error}',
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

        // Sort in-memory to avoid composite index requirement
        final sortedDocs = List<QueryDocumentSnapshot>.from(docs);
        sortedDocs.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aCreated = aData['createdAt'] as Timestamp?;
          final bCreated = bData['createdAt'] as Timestamp?;
          if (aCreated == null) return 1;
          if (bCreated == null) return -1;
          return bCreated.compareTo(aCreated); // Descending order
        });

        if (sortedDocs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "🌴",
                  style: TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  "No leave requests found",
                  style: GoogleFonts.outfit(
                    color: textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: sortedDocs.length,
          itemBuilder: (context, index) {
            final doc = sortedDocs[index];
            final data = doc.data() as Map<String, dynamic>;
            final type = data['leaveType'] ?? 'Annual';
            final status = data['status'] ?? 'pending';
            final start = data['startDate'] as Timestamp?;
            final end = data['endDate'] as Timestamp?;

            String rangeStr = '-- to --';
            if (start != null && end != null) {
              final sDate = start.toDate();
              final eDate = end.toDate();
              rangeStr = "${sDate.month}/${sDate.day} - ${eDate.month}/${eDate.day}";
            }

            // Determine badge color
            Color badgeBg;
            Color badgeTxt;
            if (status == 'approved') {
              badgeBg = successColor.withValues(alpha: 0.15);
              badgeTxt = successColor;
            } else if (status == 'rejected') {
              badgeBg = dangerColor.withValues(alpha: 0.15);
              badgeTxt = dangerColor;
            } else {
              badgeBg = warningColor.withValues(alpha: 0.15);
              badgeTxt = warningColor;
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgDark,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: borderColor, width: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$type Leave",
                        style: GoogleFonts.outfit(
                          color: textMain,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        rangeStr,
                        style: GoogleFonts.outfit(
                          color: textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      status.toString().toUpperCase(),
                      style: GoogleFonts.outfit(
                        color: badgeTxt,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _submitLeaveRequest() async {
    if (_startDate == null || _endDate == null) {
      setState(() {
        _errorMessage = "Please select start and end dates";
      });
      return;
    }
    if (_startDate!.isAfter(_endDate!)) {
      setState(() {
        _errorMessage = "Start date must be before end date";
      });
      return;
    }
    if (_leaveReasonController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = "Please enter a reason";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('leave_requests').add({
          'userId': user.uid,
          'name': _userName,
          'leaveType': _selectedLeaveType,
          'startDate': Timestamp.fromDate(_startDate!),
          'endDate': Timestamp.fromDate(_endDate!),
          'reason': _leaveReasonController.text.trim(),
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Reset fields
        setState(() {
          _startDate = null;
          _endDate = null;
          _leaveReasonController.clear();
          _isApplyingLeave = false; // Switch to requests list
        });
      } catch (e) {
        setState(() {
          _errorMessage = "Failed to submit leave request: $e";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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

  // Shift History Timeline View
  Widget _buildShiftHistory() {
    if (_historyStream == null) return const SizedBox();

    return StreamBuilder<QuerySnapshot>(
      stream: _historyStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
            child: Center(
              child: Text(
                'Error loading logs: ${snapshot.error}',
                style: GoogleFonts.outfit(color: dangerColor),
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          );
        }

        final docs = snapshot.data?.docs ?? [];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showHistory = false;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: borderColor.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            size: 16,
                            color: textMain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Shift History",
                        style: GoogleFonts.outfit(
                          color: textMain,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${docs.length} logs",
                    style: GoogleFonts.outfit(
                      color: textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Scrollable Timeline
              SizedBox(
                height: 260,
                child: docs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "⏰",
                              style: TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "No logs recorded yet",
                              style: GoogleFonts.outfit(
                                color: textMuted,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final action = data['action'] ?? 'clock_in';
                          final timestamp = data['timestamp'] as Timestamp?;
                          final isClockIn = action == 'clock_in';

                          String timeStr = '--:--';
                          String dateStr = 'Pending...';

                          if (timestamp != null) {
                            final dt = timestamp.toDate().toLocal();
                            timeStr = _formatTimeOnly(dt);
                            dateStr = _formatDateOnly(dt);
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bgDark,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: borderColor, width: 0.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isClockIn ? successColor : dangerColor,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      isClockIn ? "Clock In" : "Clock Out",
                                      style: GoogleFonts.outfit(
                                        color: textMain,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      timeStr,
                                      style: GoogleFonts.outfit(
                                        color: textMain,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dateStr,
                                      style: GoogleFonts.outfit(
                                        color: textMuted,
                                        fontSize: 11,
                                      ),
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
      },
    );
  }

  String _formatTimeOnly(DateTime dt) {
    final hr = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final min = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? 'PM' : 'AM';
    return "$hr:$min $amPm";
  }

  String _formatDateOnly(DateTime dt) {
    final now = DateTime.now();
    if (dt.day == now.day && dt.month == now.month && dt.year == now.year) {
      return "Today";
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (dt.day == yesterday.day && dt.month == yesterday.month && dt.year == yesterday.year) {
      return "Yesterday";
    }
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return "${months[dt.month - 1]} ${dt.day}, ${dt.year}";
  }

  // Developer Tasks Summary View
  Widget _buildTasksBoard() {
    if (_tasksStream == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Back Button
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _showTasks = false;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: borderColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: textMain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Tasks Workspace",
                style: GoogleFonts.outfit(
                  color: textMain,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Overview Card inside the Mockup
          StreamBuilder<QuerySnapshot>(
            stream: _tasksStream,
            builder: (context, snapshot) {
              final docs = snapshot.data?.docs ?? [];
              final todoCount = docs.where((doc) => doc['status'] == 'todo').length;
              final inProgressCount = docs.where((doc) => doc['status'] == 'in_progress').length;
              final doneCount = docs.where((doc) => doc['status'] == 'done').length;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: bgDark.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 0.5),
                ),
                child: Column(
                  children: [
                    // Icon / Illustration
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.dashboard_customize_outlined,
                        color: primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Tasks Board Workspace",
                      style: GoogleFonts.outfit(
                        color: textMain,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Manage assignments, track project status, and move cards in a clean multi-column layout.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: textMuted,
                        fontSize: 10,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Columns Counts Overview Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSummaryStat("To Do", todoCount, accentColor),
                        _buildSummaryStat("In Progress", inProgressCount, warningColor),
                        _buildSummaryStat("Done", doneCount, successColor),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Launch Full Screen CTA
                    SizedBox(
                      width: double.infinity,
                      height: 38,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: textMain,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.launch, size: 12),
                        label: Text(
                          "Launch Full Board",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        onPressed: () {
                          final user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TasksBoardPage(uid: user.uid),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String title, int count, Color badgeColor) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: GoogleFonts.outfit(
            color: textMain,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: badgeColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: textMuted,
                fontSize: 9,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
