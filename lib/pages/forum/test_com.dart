import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentPage extends StatefulWidget {
  final int indexNumber;

  const CommentPage({Key? key, required this.indexNumber}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final TextEditingController _commentController = TextEditingController();
  void _add() async {
    final String comment = _commentController.text;
    final String index = widget.indexNumber.toString();

    final Map<String, String> data = {
      'comment': comment,
      'index': index,
    };

    final Uri uri = Uri.parse('http://localhost:3000/comments');
    final http.Response response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      // Registration successful
      print('Upload comments successful');
    } else {
      // Registration failed
      print('Upload comments failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Comment',
              ),
            ),
            IconButton(
              onPressed: _add,
              icon: Icon(Icons.send),
              tooltip: 'Submit Comment',
            ),
          ],
        ),
      ),
    );
  }
}
