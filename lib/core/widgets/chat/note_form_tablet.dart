import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotesWidget extends StatefulWidget {
  const NotesWidget({Key? key}) : super(key: key);

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  final List<_Message> _messages = [];
  final TextEditingController _controller = TextEditingController();

  final String getCommentsUrl = 'https://8c08e31d-84d8-44bb-aa2e-ac6e98956308.mock.pstmn.io/getSms';
  final String postCommentUrl = 'https://your-api.com/post-comment'; // Replace with your real endpoint

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await http.get(Uri.parse(getCommentsUrl));
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

  Future<void> _addComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final newComment = _Message(content: text, isUser: true);
    setState(() {
      _messages.add(newComment);
      _controller.clear();
    });

    try {
      final response = await http.post(
        Uri.parse(postCommentUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': text}),
      );
      if (response.statusCode != 200) {
        debugPrint('Failed to post comment');
      }
    } catch (e) {
      debugPrint('Error posting comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return Card(
                    elevation: 1,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        msg.isUser ? Icons.person : Icons.engineering,
                        color: msg.isUser ? Colors.blue : Colors.grey,
                      ),
                      title: Text(msg.content),
                      subtitle: Text(msg.isUser ? "You" : "System"),
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: EdgeInsets.only(
                left: 12,
                right: 12,
                bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                top: 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addComment,
                    child: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String content;
  final bool isUser;
  _Message({required this.content, required this.isUser});
}
