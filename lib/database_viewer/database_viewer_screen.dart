import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/health_data.dart';

class DatabaseViewerScreen extends StatelessWidget {
  const DatabaseViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Box healthDataBox = Hive.box('healthData');

    return Scaffold(
      appBar: AppBar(title: const Text('Hive Database Viewer')),
      body: ValueListenableBuilder(
        valueListenable: healthDataBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text("No data available."),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final healthData = box.getAt(index) as HealthData;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                elevation: 4,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text('📊 ${healthData.metric} - ${healthData.value}'),
                  subtitle: Text('🕒 ${healthData.timestamp}'),
                  tileColor: Colors.blueGrey[50],
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => box.deleteAt(index), // Delete entry
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
