import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:template_project/models/health_data_model.dart';
import 'package:template_project/models/patient_overview_model.dart';
import 'package:template_project/providers/auth_provider.dart';
import 'package:template_project/services/api_service.dart';
import 'package:template_project/services/location_service.dart';
import 'package:template_project/theme/colors.dart';
import 'package:template_project/theme/typography.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  Future<List<HealthData>>? _healthDataFuture;
  Future<HealthRisk>? _healthRiskFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // Defer API calls until after the widget is built to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  void _initializeData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      setState(() {
        _healthDataFuture = _apiService.fetchHealthData(user.id, user.token!);
        _healthRiskFuture = _apiService.getHealthRisk(user.id, user.token!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Health Dashboard'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome, ${user?.name ?? 'User'}!', style: AppTypography.headline1),
            const SizedBox(height: 20),
            _buildRiskCard(),
            const SizedBox(height: 20),
            _buildHealthChart(),
            const SizedBox(height: 20),
            _buildEmergencyButton(),
            const SizedBox(height: 20),
            _buildHospitalsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCard() {
    if (_healthRiskFuture == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('Loading risk assessment...')),
        ),
      );
    }

    return FutureBuilder<HealthRisk>(
      future: _healthRiskFuture!,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Card(child: Center(child: Text('Could not load risk level')));
        }
        final risk = snapshot.data!;
        final riskColor = risk == HealthRisk.high ? AppColors.highRisk : 
                          risk == HealthRisk.medium ? AppColors.mediumRisk : AppColors.lowRisk;
        final riskText = risk.toString().split('.').last.toUpperCase();

        return Card(
          elevation: 4,
          color: riskColor.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: riskColor, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HEALTH RISK: $riskText', style: AppTypography.headline3.copyWith(color: riskColor)),
                      if (risk == HealthRisk.high)
                        const Text('Please consult your doctor immediately.', style: AppTypography.bodyText2),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthChart() {
    if (_healthDataFuture == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: Text('Loading health data...')),
        ),
      );
    }

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weekly Steps', style: AppTypography.headline3),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: FutureBuilder<List<HealthData>>(
                future: _healthDataFuture!,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Center(child: Text('No data available'));
                  }
                  final data = snapshot.data!;
                  final series = [
                    charts.Series<HealthData, String>(
                      id: 'Steps',
                      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                      domainFn: (HealthData health, _) => health.timestamp.day.toString(),
                      measureFn: (HealthData health, _) => health.steps,
                      data: data,
                    )
                  ];
                  return charts.BarChart(series, animate: true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.emergency_outlined),
        label: const Text('EMERGENCY ALERT'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        onPressed: () async {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          final user = authProvider.user;
          
          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User not authenticated. Please log in again.'))
            );
            return;
          }
          
          final locationService = LocationService();
          final location = await locationService.getCurrentLocation();
          
          await _apiService.sendEmergencyAlert(
            user.id, 
            user.token!,
            latitude: location['latitude']!,
            longitude: location['longitude']!,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Emergency alert sent to your doctor!'))
          );
        },
      ),
    );
  }

  Widget _buildHospitalsList() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nearby Hospitals', style: AppTypography.headline3),
            const SizedBox(height: 10),
            FutureBuilder<List<dynamic>>(
              future: LocationService().getNearbyHospitals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Could not load hospitals'));
                }
                final hospitals = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: hospitals.length,
                  itemBuilder: (context, index) {
                    final hospital = hospitals[index];
                    return ListTile(
                      leading: const Icon(Icons.local_hospital, color: AppColors.primary),
                      title: Text(hospital['name']),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}