import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:template_project/models/user_model.dart';
import 'package:template_project/models/health_data_model.dart';
import 'package:template_project/models/patient_overview_model.dart';

class ApiService {
  final String _baseUrl = 'https://api.proxi-health.com'; // Placeholder

  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real app, this would be a POST request
    // final response = await http.post(
    //   Uri.parse('$_baseUrl/auth/login'),
    //   body: jsonEncode({'email': email, 'password': password}),
    // );
    
    // Mock response
    if (email == 'user@proxi.com') {
      return User(id: 'user1', name: 'John Doe', email: email, role: UserRole.user, token: 'fake-jwt-token');
    }
    if (email == 'doctor@proxi.com') {
      return User(id: 'doc1', name: 'Dr. Smith', email: email, role: UserRole.doctor, token: 'fake-jwt-token');
    }
    return null;
  }

  Future<User?> signup(String name, String email, String password, UserRole role) async {
    await Future.delayed(const Duration(seconds: 1));
    return User(id: 'newuser', name: name, email: email, role: role, token: 'fake-jwt-token');
  }

  Future<void> logout(String token) async {
    // In a real app, you might invalidate the token on the server
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<List<HealthData>> fetchHealthData(String userId, String token) async {
    await Future.delayed(const Duration(seconds: 1));
    // Mock data
    return [
      HealthData(steps: 5234, heartRate: 72.0, calories: 340, sleepHours: 7.5, timestamp: DateTime.now().subtract(const Duration(days: 1))),
      HealthData(steps: 6789, heartRate: 75.0, calories: 420, sleepHours: 6.8, timestamp: DateTime.now().subtract(const Duration(days: 2))),
      HealthData(steps: 4123, heartRate: 68.0, calories: 280, sleepHours: 8.1, timestamp: DateTime.now().subtract(const Duration(days: 3))),
    ];
  }

  Future<HealthRisk> getHealthRisk(String userId, String token) async {
    await Future.delayed(const Duration(seconds: 2));
    // Mock response, cycle through risks
    final risks = [HealthRisk.low, HealthRisk.medium, HealthRisk.high];
    return risks[DateTime.now().second % 3];
  }

  Future<List<PatientOverview>> getPatientsForDoctor(String doctorId, String token) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      PatientOverview(id: 'user1', name: 'John Doe', latestData: HealthData(steps: 5234, heartRate: 72.0, timestamp: DateTime.now()), riskLevel: HealthRisk.low),
      PatientOverview(id: 'user2', name: 'Jane Roe', latestData: HealthData(steps: 8910, heartRate: 85.0, timestamp: DateTime.now()), riskLevel: HealthRisk.high),
      PatientOverview(id: 'user3', name: 'Peter Pan', latestData: HealthData(steps: 3100, heartRate: 65.0, timestamp: DateTime.now()), riskLevel: HealthRisk.medium),
    ];
  }

  Future<void> sendEmergencyAlert(String userId, String token, {required double latitude, required double longitude}) async {
    // print('EMERGENCY: User $userId at ($latitude, $longitude)');
    await Future.delayed(const Duration(seconds: 1));
  }
}