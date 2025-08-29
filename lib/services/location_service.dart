import 'dart:convert';
import 'package:flutter/services.dart';

class LocationService {
  // In a real app, this would use a plugin like geolocator
  Future<Map<String, double>> getCurrentLocation() async {
    // Simulate getting GPS location
    await Future.delayed(const Duration(seconds: 1));
    // Return a mock location (e.g., San Francisco)
    return {'latitude': 37.7749, 'longitude': -122.4194};
  }

  Future<List<dynamic>> getNearbyHospitals() async {
    // Load a local JSON file with hospital data
    final String response = await rootBundle.loadString('assets/data/hospitals.json');
    final data = await json.decode(response);
    return data['hospitals'];
  }
}