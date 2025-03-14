// chat_screen.dart
import 'package:flutter/material.dart';
import 'groq_api_service.dart';
import 'database_helper.dart';

// Chat message model
class ChatMessage {
  final String message;
  final bool isUser;
  ChatMessage({required this.message, required this.isUser});
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final GroqApiService _apiService = GroqApiService();

  // Example: Insert some random health data (this could be triggered by a form in your real app)
  Future<void> _insertSampleHealthData() async {
    // For demonstration, insert 3 types of health data.
    await DatabaseHelper().insertHealthData({
      'metric': 'blood_pressure',
      'value': 120,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await DatabaseHelper().insertHealthData({
      'metric': 'heart_rate',
      'value': 75,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await DatabaseHelper().insertHealthData({
      'metric': 'weight',
      'value': 70,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  // Handle user submitting a message
  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage(message: text, isUser: true));
    });

    // Call the API with the user's question plus the stored health data context.
    try {
      String reply = await _apiService.getChatCompletionWithHealthData(text);
      setState(() {
        _messages.add(ChatMessage(message: reply, isUser: false));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(message: "Error: $e", isUser: false));
      });
    }
  }

  // Build text input area
  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration:
                  const InputDecoration.collapsed(hintText: "Enter your question"),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }

  // Build individual chat message widget
  Widget _buildMessageItem(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Align(
        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.blueAccent : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            message.message,
            style: TextStyle(
              color: message.isUser ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Optionally, insert sample health data at startup
    _insertSampleHealthData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Health ChatBot"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) => _buildMessageItem(_messages[index]),
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}


// // chat_screen.dart
// import 'package:flutter/material.dart';
// import 'groq_api_service.dart';
// import 'database_helper.dart';  // Optional, for local storage


// // Chat message model
// class ChatMessage {
//   final String message;
//   final bool isUser;
//   ChatMessage({required this.message, required this.isUser});
// }

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);
  
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final List<ChatMessage> _messages = [];
//   final TextEditingController _textController = TextEditingController();
//   final GroqApiService _apiService = GroqApiService();
//   final DatabaseHelper _dbHelper = DatabaseHelper(); // Optional, for local storage

//   // Send user message to Groq API and get the response
//   Future<void> _handleSubmitted(String text) async {
//     if (text.trim().isEmpty) return;
//     _textController.clear();

//     // Add user's message to the chat list
//     setState(() {
//       _messages.add(ChatMessage(message: text, isUser: true));
//     });
//     // Optionally store user message locally
//     await _dbHelper.insertChatMessage({
//       'message': text,
//       'isUser': 1,
//       'timestamp': DateTime.now().toIso8601String(),
//     });

//     // Call the Groq API for chat completion
//     try {
//       String reply = await _apiService.getChatCompletion(text);
//       setState(() {
//         _messages.add(ChatMessage(message: reply, isUser: false));
//       });
//       // Optionally store bot reply locally
//       await _dbHelper.insertChatMessage({
//         'message': reply,
//         'isUser': 0,
//         'timestamp': DateTime.now().toIso8601String(),
//       });
//     } catch (e) {
//       setState(() {
//         _messages.add(ChatMessage(message: "Error: $e", isUser: false));
//       });
//     }
//   }

//   Widget _buildTextComposer() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       child: Row(
//         children: <Widget>[
//           Flexible(
//             child: TextField(
//               controller: _textController,
//               onSubmitted: _handleSubmitted,
//               decoration: const InputDecoration.collapsed(
//                   hintText: "Enter your message"),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: () => _handleSubmitted(_textController.text),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageItem(ChatMessage message) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
//       child: Align(
//         alignment: message.isUser
//             ? Alignment.centerRight
//             : Alignment.centerLeft,
//         child: Container(
//           padding: const EdgeInsets.all(10.0),
//           decoration: BoxDecoration(
//             color: message.isUser ? Colors.blueAccent : Colors.grey[300],
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Text(
//             message.message,
//             style: TextStyle(
//               color: message.isUser ? Colors.white : Colors.black,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Groq ChatBot"),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(8.0),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) =>
//                   _buildMessageItem(_messages[index]),
//             ),
//           ),
//           const Divider(height: 1.0),
//           Container(
//             decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor),
//             child: _buildTextComposer(),
//           ),
//         ],
//       ),
//     );
//   }
// }
