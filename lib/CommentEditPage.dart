import 'package:flutter/material.dart';
import 'package:dawgs/models/Comment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentEditPage extends StatefulWidget {
  final String? userId;
  final int discussionId;
  final Comment comment;

  CommentEditPage({
    Key? key,
    required this.userId,
    required this.discussionId,
    required this.comment,
  }) : super(key: key);

  @override
  _CommentEditPageState createState() => _CommentEditPageState();
}

class _CommentEditPageState extends State<CommentEditPage> {
  late TextEditingController _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.comment.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Comment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _editingController,
              decoration: InputDecoration(
                labelText: 'Edit your comment',
                border: OutlineInputBorder(),
              ),
              minLines: 3,
              maxLines: null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _editComment(widget.userId, widget.discussionId,
                    widget.comment.id, _editingController.text);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editComment(String? userId, int discussionId, int commentId,
      String editedMessage) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://team-dawgs.dokku.cse.lehigh.edu/comments/$discussionId/$commentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'mContent': editedMessage,
        }),
      );

      if (response.statusCode == 200) {
        // Navigate back to the comment page after editing
        Navigator.pop(context);
      } else {
        throw Exception(
            'Failed to edit comment. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in editing comment: $error');
    }
  }
}
