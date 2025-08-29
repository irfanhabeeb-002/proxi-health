class HealthData {
  final int? steps;
  final double? heartRate;
  final int? calories;
  final double? sleepHours;
  final DateTime timestamp;

  HealthData({
    this.steps,
    this.heartRate,
    this.calories,
    this.sleepHours,
    required this.timestamp,
  });

  factory HealthData.fromJson(Map<String, dynamic> json) {
    return HealthData(
      steps: json['steps'],
      heartRate: json['heart_rate']?.toDouble(),
      calories: json['calories'],
      sleepHours: json['sleep_hours']?.toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}