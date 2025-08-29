import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proxi_health/models/patient_overview_model.dart';
import 'package:proxi_health/providers/auth_provider.dart';
import 'package:proxi_health/services/api_service.dart';
import 'package:proxi_health/theme/colors.dart';
import 'package:proxi_health/theme/typography.dart';
import 'package:proxi_health/widgets/proxi_logo.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  late Future<List<PatientOverview>> _patientsFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user!;
    _patientsFuture = _apiService.getPatientsForDoctor(user.id, user.token!);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const ProxiLogo.small(),
            const SizedBox(width: 12),
            const Text('Patient Dashboard'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Welcome, ${user?.name ?? 'Doctor'}!', style: AppTypography.headline1),
          ),
          Expanded(
            child: FutureBuilder<List<PatientOverview>>(
              future: _patientsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Could not load patient data.'));
                }
                final patients = snapshot.data!;
                return ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, index) {
                    final patient = patients[index];
                    return _buildPatientCard(patient);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(PatientOverview patient) {
    final risk = patient.riskLevel ?? HealthRisk.low;
    final riskColor = risk == HealthRisk.high ? AppColors.highRisk : 
                      risk == HealthRisk.medium ? AppColors.mediumRisk : AppColors.lowRisk;
    final riskText = risk.toString().split('.').last.toUpperCase();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(patient.name, style: AppTypography.headline3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: riskColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(riskText, style: AppTypography.button.copyWith(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Steps', patient.latestData?.steps?.toString() ?? 'N/A', Icons.directions_walk),
                _buildStat('Heart Rate', patient.latestData?.heartRate?.toStringAsFixed(0) ?? 'N/A', Icons.favorite),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(height: 4),
        Text(value, style: AppTypography.headline2),
        Text(label, style: AppTypography.bodyText2),
      ],
    );
  }
}