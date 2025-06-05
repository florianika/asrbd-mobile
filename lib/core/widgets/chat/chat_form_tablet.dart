import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatWidget extends StatefulWidget {
  const ChatWidget({Key? key}) : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();
  final List<_Message> _messages = [];

  final String getChatsUrl = 'https://8c08e31d-84d8-44bb-aa2e-ac6e98956308.mock.pstmn.io/getSms';
  final String postChatUrl = 'https://your-api.com/post-chat';

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(getChatsUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _messages.clear();
          _messages.addAll(data.map((item) => _Message(
                content: item['message'],
                isUser: item['isUser'],
              )));
        });
      }
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newMessage = _Message(content: text, isUser: true);
    setState(() {
      _messages.add(newMessage);
    });
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(postChatUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'message': text,
        }),
      );
      if (response.statusCode != 200) {
        debugPrint('Failed to send message');
      }
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Align(
                alignment: message.isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: message.isUser ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.black), 
                  decoration: const InputDecoration(
                  hintText: 'Message',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                 ),
                ),
               ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _sendMessage,
                child: const Icon(Icons.send),
              )
            ],
          ),
        )
      ],
    );
  }
}
class _Message {
  final String content;
  final bool isUser;
  _Message({required this.content, required this.isUser});
}
