import 'package:flutter/material.dart';
import 'package:genhealth/hive_helper.dart';
import 'package:genhealth/models/health_data.dart';
import 'package:genhealth/models/user_data.dart';
import 'package:genhealth/view/on_boarding/started_view.dart';
import 'common/colo_extenstion.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'chat_screen.dart';

import 'conversation_screen.dart'; // Updated Import
import 'database_viewer/database_viewer_screen.dart';

import 'package:hive_ui/hive_ui.dart'; // Added Hive UI import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(HealthDataAdapter()); // Register the adapter
  Hive.registerAdapter(UserDataAdapter()); // Register UserData adapter
  await Hive.openBox('healthData'); // Open Hive Box
  await Hive.openBox<UserData>('userBox'); // Open User Box
  
  // Insert sample health data
  List<HealthData> sampleData = [
    HealthData(metric: "Heart Rate", value: 72, timestamp: DateTime.now().toString()),
    HealthData(metric: "Blood Pressure", value: 120.80, timestamp: DateTime.now().toString()),
    HealthData(metric: "Body Temperature", value: 36.5, timestamp: DateTime.now().toString()),
    HealthData(metric: "Steps Count", value: 8500, timestamp: DateTime.now().toString()),
    HealthData(metric: "Calorie Intake", value: 2200, timestamp: DateTime.now().toString()),
  ];

  for (var data in sampleData) {
    await HiveHelper().insertHealthData(data);
  }

  var records = HiveHelper().fetchAllHealthData();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness 3 in 1',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: TColor.primaryColor1,
        fontFamily: "Poppins",
      ),
      home: const StartedView(),
      // home: const ChatScreen(),
    );
  }
}

// ____


// import 'user_data_view.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Hive.initFlutter();
//   Hive.registerAdapter(UserDataAdapter());
//   await Hive.openBox<UserData>('userBox');

//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Hive Database Viewer',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const UserDataView(),
//     );
//   }
// }




