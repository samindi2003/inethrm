import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color bgDark = Color(0xFF0F172A);
const Color bgCard = Color(0xFF1E293B);
const Color primaryColor = Color(0xFF6366F1);
const Color accentColor = Color(0xFF06B6D4);
const Color textMain = Color(0xFFF8FAFC);
const Color textMuted = Color(0xFF94A3B8);
const Color borderColor = Color(0xFF334155);
const Color dangerColor = Color(0xFFEF4444);

class EmployeeProfilePage extends StatefulWidget {
  const EmployeeProfilePage({super.key});

  @override
  State<EmployeeProfilePage> createState() => _EmployeeProfilePageState();
}

class _EmployeeProfilePageState extends State<EmployeeProfilePage> {
  bool _isLoading = true;
  String _errorMessage = '';

  String _name = 'Employee';
  String _email = '';
  String _role = 'Junior Developer';
  String _department = 'Engineering Department';
  String _phone = 'Not added';
  String _joiningDate = 'Not available';
  final TextEditingController _nameController = TextEditingController();
final TextEditingController _phoneController = TextEditingController();
final TextEditingController _roleController = TextEditingController();
final TextEditingController _departmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEmployeeProfile();
  }

  Future<void> _loadEmployeeProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'No logged-in user found';
      });
      return;
    }

    try {
      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!document.exists) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Employee profile not found';
        });
        return;
      }

      final data = document.data()!;
final TextEditingController _nameController =
    TextEditingController();

final TextEditingController _phoneController =
    TextEditingController();

final TextEditingController _roleController =
    TextEditingController();

final TextEditingController _departmentController =
    TextEditingController();
      String joiningDate = 'Not available';

      final createdAt = data['createdAt'];

      if (createdAt is Timestamp) {
        final date = createdAt.toDate();

        joiningDate =
            '${date.day.toString().padLeft(2, '0')}/'
            '${date.month.toString().padLeft(2, '0')}/'
            '${date.year}';
      }

      setState(() {
        _name = data['name'] ?? 'Employee';
        _email = data['email'] ?? user.email ?? '';
        _role = data['role'] ?? 'Junior Developer';
        _department =
            data['department'] ?? 'Engineering Department';
        _phone = data['phone'] ?? 'Not added';
        _joiningDate = joiningDate;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load profile: $error';
      });
    }
  }
Future<void> _showEditProfileDialog() async {
  _nameController.text = _name;
  _phoneController.text =
      _phone == 'Not added' ? '' : _phone;
  _roleController.text = _role;
  _departmentController.text = _department;

  await showDialog(
    context: context,
    builder: (dialogContext) {
      bool isSaving = false;

      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: bgCard,
            title: Text(
              'Edit Profile',
              style: GoogleFonts.outfit(
                color: textMain,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: SizedBox(
              width: 450,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEditField(
                      controller: _nameController,
                      label: 'Employee Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    _buildEditField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone_outlined,
                    ),
                    const SizedBox(height: 14),
                    _buildEditField(
                      controller: _roleController,
                      label: 'Role',
                      icon: Icons.work_outline,
                    ),
                    const SizedBox(height: 14),
                    _buildEditField(
                      controller: _departmentController,
                      label: 'Department',
                      icon: Icons.business_outlined,
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving
                    ? null
                    : () {
                        Navigator.pop(dialogContext);
                      },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isSaving
                    ? null
                    : () async {
                        final user =
                            FirebaseAuth.instance.currentUser;

                        if (user == null) {
                          return;
                        }

                        if (_nameController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(this.context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Employee name is required',
                              ),
                            ),
                          );
                          return;
                        }

                        setDialogState(() {
                          isSaving = true;
                        });

                        try {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update({
                            'name':
                                _nameController.text.trim(),
                            'phone':
                                _phoneController.text.trim(),
                            'role':
                                _roleController.text.trim(),
                            'department':
                                _departmentController.text.trim(),
                          });

                          if (!mounted) return;

                          setState(() {
                            _name =
                                _nameController.text.trim();

                            _phone =
                                _phoneController.text.trim().isEmpty
                                    ? 'Not added'
                                    : _phoneController.text.trim();

                            _role =
                                _roleController.text.trim();

                            _department =
                                _departmentController.text.trim();
                          });

                          Navigator.pop(dialogContext);

                          ScaffoldMessenger.of(this.context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Profile updated successfully',
                              ),
                            ),
                          );
                        } catch (error) {
                          setDialogState(() {
                            isSaving = false;
                          });

                          ScaffoldMessenger.of(this.context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to update profile: $error',
                              ),
                            ),
                          );
                        }
                      },
                child: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ],
          );
        },
      );
    },
  );
}
  String _getInitials(String name) {
    final parts = name.trim().split(' ');

    if (parts.isEmpty || parts.first.isEmpty) {
      return 'E';
    }

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return parts[0][0].toUpperCase();
  }
@override
void dispose() {
  _nameController.dispose();
  _phoneController.dispose();
  _roleController.dispose();
  _departmentController.dispose();
  super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: bgCard,
        foregroundColor: textMain,
        elevation: 0,
        title: Text(
          'Employee Profile',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    _errorMessage,
                    style: GoogleFonts.outfit(
                      color: dangerColor,
                      fontSize: 15,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Container(
                      constraints:
                          const BoxConstraints(maxWidth: 600),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor,
                                  accentColor,
                                ],
                              ),
                            ),
                            child: Center(
                              child: Text(
                                _getInitials(_name),
                                style: GoogleFonts.outfit(
                                  color: textMain,
                                  fontSize: 34,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              color: textMain,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _role,
                            style: GoogleFonts.outfit(
                              color: accentColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildProfileItem(
                            icon: Icons.email_outlined,
                            title: 'Email Address',
                            value: _email,
                          ),
                          _buildProfileItem(
                            icon: Icons.work_outline,
                            title: 'Role',
                            value: _role,
                          ),
                          _buildProfileItem(
                            icon: Icons.business_outlined,
                            title: 'Department',
                            value: _department,
                          ),
                          _buildProfileItem(
                            icon: Icons.phone_outlined,
                            title: 'Phone Number',
                            value: _phone,
                          ),
                          _buildProfileItem(
                            icon: Icons.calendar_month_outlined,
                            title: 'Joining Date',
                            value: _joiningDate,
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _showEditProfileDialog,
                              icon: const Icon(Icons.edit_outlined),
                              label: Text(
                                'Edit Profile',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: textMain,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
Widget _buildEditField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
}) {
  return TextField(
    controller: controller,
    style: GoogleFonts.outfit(
      color: textMain,
    ),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.outfit(
        color: textMuted,
      ),
      prefixIcon: Icon(
        icon,
        color: accentColor,
      ),
      filled: true,
      fillColor: bgDark,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          color: primaryColor,
        ),
      ),
    ),
  );
}
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    color: textMain,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}