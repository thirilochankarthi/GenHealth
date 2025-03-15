import 'package:flutter/material.dart';
import 'package:genhealth/hive_helper.dart';
import 'package:genhealth/models/health_data.dart';
import 'package:genhealth/view/on_boarding/started_view.dart';
import 'common/colo_extenstion.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(HealthDataAdapter()); // Register the adapter
  await Hive.openBox('healthData'); // Open Hive Box
  
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
      //home: const StartedView(),
      home: const ChatScreen(), // Start with ChatScreen
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:genhealth/common/colo_extenstion.dart';
// import 'package:genhealth/view/login/signup_view.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'GenHealth',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         primaryColor: TColor.primaryColor1,
//         fontFamily: "Poppins"
//       ),
//       //home: const OnBoardingView(),
//       home: const SignUpView(),
//       // home: const StartedView(),
//     );
//   }
// }

