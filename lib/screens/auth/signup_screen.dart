import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template_project/models/user_model.dart';
import 'package:template_project/providers/auth_provider.dart';

import 'package:template_project/widgets/app_logo.dart';
import 'package:template_project/widgets/custom_text_field.dart';
import 'package:template_project/widgets/primary_button.dart';
import 'package:template_project/screens/user/user_dashboard_screen.dart';
import 'package:template_project/screens/doctor/doctor_dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserRole _selectedRole = UserRole.user;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.signup(
          _nameController.text,
          _emailController.text,
          _passwordController.text,
          _selectedRole,
        );

        if (success && mounted) {
          // Navigate based on user role
          if (authProvider.user?.role == UserRole.user) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
              (route) => false,
            );
          } else {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
              (route) => false,
            );
          }
        }
      } catch (e) {
        if (!mounted) return;
        String message = 'Signup failed. Please try again.';
        final error = e.toString();
        if (error.contains('email-already-in-use')) {
          message = 'An account with this email already exists.';
        } else if (error.contains('weak-password')) {
          message = 'The password provided is too weak.';
        } else if (error.contains('invalid-email')) {
          message = 'The email address is not valid.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(size: 40),
                  const SizedBox(height: 30),
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'Full Name',
                    icon: Icons.person,
                    validator: (value) => (value?.isEmpty ?? true) ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => (value?.isEmpty ?? true) ? 'Enter an email' : null,
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    icon: Icons.lock,
                    isPassword: true,
                    validator: (value) => (value?.length ?? 0) < 6 ? 'Password must be 6+ chars' : null,
                  ),
                  const SizedBox(height: 20),
                  _buildRoleSelector(),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    text: 'Sign Up',
                    onPressed: _signup,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('I am a:', style: TextStyle(fontSize: 16)),
        Row(
          children: [
            Radio<UserRole>(
              value: UserRole.user,
              groupValue: _selectedRole,
              onChanged: (UserRole? value) {
                if (value != null) setState(() => _selectedRole = value);
              },
            ),
            const Text('User / Patient'),
            Radio<UserRole>(
              value: UserRole.doctor,
              groupValue: _selectedRole,
              onChanged: (UserRole? value) {
                if (value != null) setState(() => _selectedRole = value);
              },
            ),
            const Text('Doctor'),
          ],
        ),
      ],
    );
  }
}