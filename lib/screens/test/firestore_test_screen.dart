import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proxi_health/services/firestore_service.dart';
import 'package:proxi_health/models/user_model.dart';
import 'package:proxi_health/theme/colors.dart';
import 'package:proxi_health/theme/typography.dart';
import 'package:proxi_health/widgets/primary_button.dart';

class FirestoreTestScreen extends StatefulWidget {
  const FirestoreTestScreen({super.key});

  @override
  State<FirestoreTestScreen> createState() => _FirestoreTestScreenState();
}

class _FirestoreTestScreenState extends State<FirestoreTestScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Irfan';
    _emailController.text = 'irfan@example.com';
  }

  Future<void> _addUser() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      setState(() {
        _message = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      // Add user directly to Firestore collection
      await FirebaseFirestore.instance.collection("users").add({
        "name": _nameController.text,
        "email": _emailController.text,
        "createdAt": DateTime.now(),
        "role": "user",
      });

      setState(() {
        _message = 'User added successfully!';
        _isLoading = false;
      });

      // Clear the form
      _nameController.clear();
      _emailController.clear();
    } catch (e) {
      setState(() {
        _message = 'Error adding user: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addTestUser() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      await FirestoreService.addUser(
        uid: 'test-user-${DateTime.now().millisecondsSinceEpoch}',
        name: 'Irfan',
        email: 'irfan@example.com',
        role: UserRole.patient,
      );
      setState(() {
        _message = 'Test user (Irfan) added successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Error adding test user: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _addHealthData() async {
    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      await FirestoreService.addHealthData(
        userId: 'test_user_123',
        heartRate: 72.0,
        bloodPressureSystolic: 120.0,
        bloodPressureDiastolic: 80.0,
        temperature: 98.6,
        weight: 70.0,
        notes: 'Test health data entry',
      );

      setState(() {
        _message = 'Health data added successfully!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _message = 'Error adding health data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firestore Test',
          style: AppTypography.headline3.copyWith(
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Test Firestore Integration',
              style: AppTypography.headline3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Name input
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            
            // Email input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            
            // Add User Button
            PrimaryButton(
              text: _isLoading ? 'Adding...' : 'Add User',
              onPressed: _isLoading ? null : _addUser,
            ),
            const SizedBox(height: 16),
            
            // Add Test User Button
            PrimaryButton(
              text: 'Add Test User (Irfan)',
              onPressed: _isLoading ? null : _addTestUser,
            ),
            const SizedBox(height: 16),
            
            // Add Health Data Button
            PrimaryButton(
              text: 'Add Sample Health Data',
              onPressed: _isLoading ? null : _addHealthData,
            ),
            const SizedBox(height: 24),
            
            // Message display
            if (_message.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _message.contains('Error') 
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _message.contains('Error') 
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
                child: Text(
                  _message,
                  style: AppTypography.bodyText1.copyWith(
                    color: _message.contains('Error') 
                        ? Colors.red
                        : Colors.green,
                  ),
                ),
              ),
            
            const SizedBox(height: 24),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Instructions:',
                    style: AppTypography.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '1. Fill in name and email, then tap "Add User"\n'
                    '2. Or use "Add Test User" for quick testing\n'
                    '3. Check your Firebase Console to see the data\n'
                    '4. "Add Sample Health Data" creates test health records',
                    style: AppTypography.bodyText2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}