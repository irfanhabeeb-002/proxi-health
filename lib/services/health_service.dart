import 'package:proxi_health/models/health_data_model.dart';

class HealthService {
  // In a real app, this would use plugins like health or health_kit
  Future<List<HealthData>> getHealthDataFromSource() async {
    // Simulate fetching from Google Fit / Apple HealthKit
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Return sample data
    return [
      HealthData(steps: 4201, heartRate: 78, calories: 310, sleepHours: 6.5, timestamp: DateTime.now().subtract(const Duration(days: 0))),
      HealthData(steps: 5312, heartRate: 76, calories: 380, sleepHours: 7.2, timestamp: DateTime.now().subtract(const Duration(days: 1))),
      HealthData(steps: 6123, heartRate: 80, calories: 450, sleepHours: 8.0, timestamp: DateTime.now().subtract(const Duration(days: 2))),
    ];
  }
}