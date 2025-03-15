import 'package:hive/hive.dart';
import 'models/health_data.dart';

class HiveHelper {
  static Box get healthBox => Hive.box('healthData');

  // Insert health data
  Future<void> insertHealthData(HealthData data) async {
    await healthBox.add(data);
  }

  // Fetch all health data
  List<HealthData> fetchAllHealthData() {
    return healthBox.values.cast<HealthData>().toList();
  }
}
