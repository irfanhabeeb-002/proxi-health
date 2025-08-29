import 'package:proxi_health/models/health_data_model.dart';

enum HealthRisk { low, medium, high }

class PatientOverview {
  final String id;
  final String name;
  final HealthData? latestData;
  final HealthRisk? riskLevel;

  PatientOverview({
    required this.id,
    required this.name,
    this.latestData,
    this.riskLevel,
  });
}