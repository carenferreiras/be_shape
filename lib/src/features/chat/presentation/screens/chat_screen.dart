// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../../features.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ChatService _chatService = ChatService();
  bool _isLoading = false;

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": _controller.text});
      _isLoading = true;
    });

    final response = await _chatService.sendMessage(_controller.text);

    setState(() {
      _messages.add({"role": "assistant", "content": response});
      _isLoading = false;
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assistente de Saúde"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message["role"] == "user";
                return Container(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(message["content"] ?? ""),
                );
              },
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Digite sua mensagem...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}