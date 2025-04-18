import 'dart:convert';
import 'package:http/http.dart' as http;
import 'hive_helper.dart';
import 'models/health_data.dart';

class GroqApiService {
  static const String _apiKey = "API_KEY_HERE"; // Replace with your actual API key
  static const String _baseUrl = 'https://api.groq.com/openai/v1';

  Future<String> getChatCompletionWithHealthData(String userMessage) async {
    // Fetch health data from Hive
    final healthDataRecords = HiveHelper().fetchAllHealthData();

    // Convert health data into context string
    String healthContext = healthDataRecords.isNotEmpty
        ? healthDataRecords.map((record) => "${record.metric}: ${record.value}").join(", ")
        : "No health data available.";

    // Combine health data with user message
    final completeMessage = "User Health Data: $healthContext. Question: $userMessage";

    final url = Uri.parse('$_baseUrl/chat/completions');
    final body = jsonEncode({
      'messages': [
        {'role': 'user', 'content': completeMessage}
      ],
      'model': 'llama-3.3-70b-versatile',
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'] ?? 'No response';
    } else {
      throw Exception('Failed to get chat completion: ${response.statusCode}');
    }
  }
}
