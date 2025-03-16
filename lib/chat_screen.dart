import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For clipboard functionality
import 'groq_api_service.dart';
import 'hive_helper.dart';
import 'models/health_data.dart';


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
  final FocusNode _focusNode = FocusNode(); // To handle enter key
  final GroqApiService _apiService = GroqApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return GestureDetector(
                  onLongPress: () {
                    if (!message.isUser) {
                      Clipboard.setData(ClipboardData(text: message.message));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Copied to clipboard!")),
                      );
                    }
                  },
                  child: ListTile(
                    title: Text(
                      message.message,
                      textAlign: message.isUser ? TextAlign.right : TextAlign.left,
                      style: TextStyle(
                        color: message.isUser ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _focusNode,
              decoration: const InputDecoration(hintText: "Type a message"),
              onSubmitted: (text) => _handleSubmitted(text), // Handles Enter key
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

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus(); // Keeps focus for faster input

    setState(() {
      _messages.add(ChatMessage(message: text, isUser: true));
    });

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
}
