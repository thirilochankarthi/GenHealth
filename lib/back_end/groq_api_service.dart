// groq_api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_helper.dart';

class GroqApiService {
  // Read API key from compile-time environment variables
  static const String _apiKey = String.fromEnvironment('GROQ_API_KEY');
  // Base URL for the Groq API
  static const String _baseUrl = 'https://api.groq.com/openai/v1';

  // This method fetches stored health data, appends it as context to the user query, and calls the Groq API.
  Future<String> getChatCompletionWithHealthData(String userMessage) async {
    // Fetch health data from local SQLite database
    final healthDataRecords = await DatabaseHelper().fetchAllHealthData();

    // Build a context string from the health data (for example, list each metric and its value)
    String healthContext = "";
    if (healthDataRecords.isNotEmpty) {
      List<String> contextParts = [];
      for (var record in healthDataRecords) {
        contextParts.add("${record['metric']}: ${record['value']}");
      }
      healthContext = contextParts.join(", ");
    } else {
      healthContext = "No health data available.";
    }

    // Combine health data context with the user's message
    final completeMessage =
        "User Health Data: $healthContext. Question: $userMessage";

    final url = Uri.parse('$_baseUrl/chat/completions');
    final body = jsonEncode({
      'messages': [
        {
          'role': 'user',
          'content': completeMessage,
        }
      ],
      'model': 'llama-3.3-70b-versatile'
    });
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Assuming the API returns a JSON with a 'reply' field within choices
      return data['choices'][0]['message']['content'] ?? 'No response';
    } else {
      throw Exception('Failed to get chat completion: ${response.statusCode}');
    }
  }
}


// // groq_api_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class GroqApiService {
//   // Read your API key from the environment (set via --dart-define)
//   static const String _apiKey = String.fromEnvironment('GROQ_API_KEY');

//   // Replace with your actual API base URL if different.
//   static const String _baseUrl = 'https://api.groq.com/openai/v1';

//   Future<String> getChatCompletion(String userMessage) async {
//     final url = Uri.parse('$_baseUrl/chat/completions');
//     final body = jsonEncode({
//       'messages': [
//         {
//           'role': 'user',
//           'content': userMessage,
//         }
//       ],
//       'model': 'llama-3.3-70b-versatile'
//     });
//     final headers = {
//       'Content-Type': 'application/json',
//       // Use the API key in an Authorization header. Adjust if your API requires a different header.
//       'Authorization': 'Bearer $_apiKey',
//     };

//     final response = await http.post(url, headers: headers, body: body);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       // Expected structure: { "choices": [ { "message": { "content": "..." } } ] }
//       return data['choices'][0]['message']['content'] ?? 'No response';
//     } else {
//       throw Exception('Failed to get chat completion: ${response.statusCode}');
//     }
//   }
// }
