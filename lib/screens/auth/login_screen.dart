import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxi_health/providers/auth_provider.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';
import 'package:proxi_health/widgets/custom_text_field.dart';
import 'package:proxi_health/widgets/primary_button.dart';
import 'package:proxi_health/screens/auth/signup_screen.dart';
import 'package:proxi_health/screens/user/user_dashboard_screen.dart';
import 'package:proxi_health/screens/doctor/doctor_dashboard_screen.dart';
import 'package:proxi_health/models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final success = await authProvider.login(
          _emailController.text,
          _passwordController.text,
        );

        if (success && mounted) {
          if (authProvider.user?.role == UserRole.patient) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const UserDashboardScreen()),
            );
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DoctorDashboardScreen()),
            );
          }
        }
      } catch (e) {
        if (!mounted) return;
        String message = 'Login failed. Please try again.';
        final error = e.toString();
        if (error.contains('user-not-found') || error.contains('wrong-password')) {
          message = 'Incorrect email or password.';
        } else if (error.contains('invalid-email')) {
          message = 'The email address is not valid.';
        } else if (error.contains('network')) {
          message = 'Network error. Please check your connection.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ProxiLogo(width: 80, height: 80),
                  const SizedBox(height: 40),
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
                    validator: (value) => (value?.isEmpty ?? true) ? 'Enter a password' : null,
                  ),
                  const SizedBox(height: 30),
                  PrimaryButton(
                    text: 'Sign In',
                    onPressed: _login,
                    isLoading: authProvider.authState == AuthState.authenticating,
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      );
                    },
                    child: const Text("Don't have an account? Sign Up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}