import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/health_data.dart';
import 'package:share_plus/share_plus.dart'; // For CSV Export

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final Box _healthDataBox = Hive.box('healthData');
  String _searchQuery = "";
  String _selectedMetric = "All";
  bool _isSortedByTimestamp = true;

  List<HealthData> getFilteredData() {
    final allData = _healthDataBox.values.toList().cast<HealthData>();

    return allData
        .where((data) =>
            (_selectedMetric == "All" || data.metric == _selectedMetric) &&
            data.metric.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList()
      ..sort((a, b) => _isSortedByTimestamp
          ? a.timestamp.compareTo(b.timestamp)
          : a.metric.compareTo(b.metric));
  }

  void _exportDataToCSV() {
    final data = getFilteredData();
    if (data.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No data available to export.")),
      );
      return;
    }

    final csvContent = [
      "Metric,Value,Timestamp",
      ...data.map((d) => "${d.metric},${d.value},${d.timestamp}")
    ].join("\n");

    Share.share(csvContent, subject: "Exported Health Data (CSV)");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health Data Viewer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export as CSV',
            onPressed: _exportDataToCSV,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterAndSearchBar(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _healthDataBox.listenable(),
              builder: (context, Box box, _) {
                final data = getFilteredData();

                if (data.isEmpty) {
                  return const Center(
                    child: Text("No data available."),
                  );
                }

                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final healthData = data[index];
                    return Card(
                      margin:
                          const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(
                          '📊 ${healthData.metric} - ${healthData.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('🕒 ${healthData.timestamp}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => box.deleteAt(index),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterAndSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Search by Metric...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                value: _selectedMetric,
                items: [
                  "All",
                  "Heart Rate",
                  "Blood Pressure",
                  "Body Temperature",
                  "Steps Count",
                  "Calorie Intake"
                ]
                    .map((metric) => DropdownMenuItem(
                          value: metric,
                          child: Text(metric),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMetric = value!;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sort By:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  const Text("Timestamp"),
                  Switch(
                    value: _isSortedByTimestamp,
                    onChanged: (value) {
                      setState(() {
                        _isSortedByTimestamp = value;
                      });
                    },
                  ),
                  const Text("Metric"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
