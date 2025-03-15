import 'package:hive/hive.dart';

part 'health_data.g.dart'; // Required for Hive type adapter generation

@HiveType(typeId: 0)
class HealthData {
  @HiveField(0)
  String metric;

  @HiveField(1)
  double value;

  @HiveField(2)
  String timestamp;

  HealthData({required this.metric, required this.value, required this.timestamp});
}
