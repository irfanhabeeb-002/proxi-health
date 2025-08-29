import 'package:flutter/material.dart';
import 'package:proxi_health/models/user_model.dart';
import 'package:proxi_health/services/auth_service.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  UserRole? _selectedRole;
  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedRole == null) {
      setState(() {
        _statusMessage = 'Please select your role';
        _isSuccess = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = null;
    });

    try {
      final result = await AuthService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole!,
      );

      setState(() {
        _isLoading = false;
        if (result.success) {
          _statusMessage = 'Account created successfully! Welcome to Proxi Health.';
          _isSuccess = true;
          // Clear form on success
          _emailController.clear();
          _passwordController.clear();
          _selectedRole = null;
        } else {
          _statusMessage = result.safeErrorMessage;
          _isSuccess = false;
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'An unexpected error occurred. Please try again.';
        _isSuccess = false;
      });
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!AuthService.isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (!AuthService.isValidPassword(value)) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProxiLogo(size: 80),
              const SizedBox(height: 24),
              Text(
                'Create Your Account',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Email field
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: _validateEmail,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 16),
              
              // Password field
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                  helperText: 'Minimum 6 characters',
                ),
                validator: _validatePassword,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 24),
              
              // Role selection
              const Text(
                'Select your role:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              
              // Patient radio button
              RadioListTile<UserRole>(
                title: const Text('Patient'),
                subtitle: const Text('I want to track my health data'),
                value: UserRole.patient,
                groupValue: _selectedRole,
                onChanged: _isLoading ? null : (UserRole? value) {
                  setState(() {
                    _selectedRole = value;
                    _statusMessage = null; // Clear any role selection error
                  });
                },
              ),
              
              // Doctor radio button
              RadioListTile<UserRole>(
                title: const Text('Doctor'),
                subtitle: const Text('I want to monitor patients'),
                value: UserRole.doctor,
                groupValue: _selectedRole,
                onChanged: _isLoading ? null : (UserRole? value) {
                  setState(() {
                    _selectedRole = value;
                    _statusMessage = null; // Clear any role selection error
                  });
                },
              ),
              
              const SizedBox(height: 24),
              
              // Signup button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Creating Account...'),
                        ],
                      )
                    : const Text(
                        'Create Account',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              
              const SizedBox(height: 24),
              
              // Status message
              if (_statusMessage != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isSuccess ? Colors.green[50] : Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isSuccess ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isSuccess ? Icons.check_circle : Icons.error,
                        color: _isSuccess ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _statusMessage!,
                          style: TextStyle(
                            color: _isSuccess ? Colors.green[800] : Colors.red[800],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Instructions
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Getting Started:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '1. Enter your email and create a secure password\n'
                      '2. Choose your role (Patient or Doctor)\n'
                      '3. Click "Create Account" to get started\n'
                      '4. Your account will be ready to use immediately',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}