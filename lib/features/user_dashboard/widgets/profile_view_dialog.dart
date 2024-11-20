// lib/features/user_dashboard/widgets/profile_view_dialog.dart
import 'package:flutter/material.dart';
import '../../auth/models/user_model.dart' as auth;

class ProfileViewDialog extends StatelessWidget {
  final auth.User currentUser;

  const ProfileViewDialog({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: const Color(0xFF242F40),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildProfileInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFCCA43B), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Profile Information',
            style: TextStyle(
              color: Color(0xFFCCA43B),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Color(0xFFCCA43B)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            title: 'Personal Information',
            items: [
              InfoItem(label: 'Full Name', value: '${currentUser.name} ${currentUser.surname}'),
              InfoItem(label: 'ID Number', value: currentUser.idNumber),
              InfoItem(label: 'Email', value: currentUser.email),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoSection(
            title: 'Location Details',
            items: [
              InfoItem(label: 'Province', value: currentUser.province),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoSection(
            title: 'Account Information',
            items: [
              InfoItem(label: 'Role', value: currentUser.role),
              InfoItem(
                label: 'Registration Date',
                value: currentUser.createdAt.toLocal().toString().split(' ')[0],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<InfoItem> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFCCA43B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF2A3750),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: items.map((item) => _buildInfoRow(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(InfoItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF3A4760), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              item.label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              item.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoItem {
  final String label;
  final String value;

  InfoItem({required this.label, required this.value});
}