import 'dart:ffi';

import 'package:dawgs/CommentEditPage.dart';
import 'package:flutter/material.dart';
import 'package:dawgs/components/text_field.dart';
import 'package:dawgs/models/Discussion.dart';
import 'package:dawgs/models/Comment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentPage extends StatefulWidget {
  String? userId;
  int discussionId;

  CommentPage({Key? key, required this.userId, required this.discussionId})
      : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final messageController = TextEditingController();
  late Future<List<Comment>> _futureListComments;

  @override
  void initState() {
    super.initState();
    _futureListComments = fetchComments(widget.discussionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comment Page'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _futureListComments,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Comment>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                } else {
                  // Check if snapshot has data or not
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final comment = snapshot.data![index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        comment.message,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // Navigate to comment edit page when pencil button is pressed
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CommentEditPage(
                                              userId: widget.userId,
                                              discussionId: widget.discussionId,
                                              comment: comment,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    // Render a placeholder text if no comments available
                    return Center(
                      child: Text(
                        'No comments available',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: messageController,
                    hintText: 'Comment?',
                    obscureText: false,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Functionality for posting a comment
                    print(widget.discussionId);
                    postComment(widget.userId, widget.discussionId,
                        messageController.text);
                  },
                  icon: const Icon(Icons.arrow_circle_up),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Comment>> postComment(
      String? userId, int discussionId, String message) async {
    try {
      final response = await http.post(
        Uri.parse('https://team-dawgs.dokku.cse.lehigh.edu/comments'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'userId': userId,
          'discussionId': discussionId,
          'mContent': message,
        }),
      );

      if (response.statusCode == 200) {
        // Construct a list with a single discussion object
        final comment = getCommentFromResponse(response);
        return [comment];
      } else {
        throw Exception(
            'Failed to post discussion. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error in postDiscussion: $error');
      // Return an empty list if an error occurs
      return [];
    }
  }

  Comment getCommentFromResponse(http.Response response) {
    try {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final comment = Comment.fromJson(responseData);
      return comment;
    } catch (e) {
      print('Error parsing discussion from response: $e');
      throw Exception('Failed to parse discussion from response.');
    }
  }

  Future<List<Comment>> fetchComments(int discussionId) async {
    final response = await http.get(Uri.parse(
        'https://team-dawgs.dokku.cse.lehigh.edu/comments/$discussionId'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      var res = jsonDecode(response.body);
      print('json decode: $res'); // Print decoded JSON data

      List<dynamic> mData = res['mData'];
      mData.forEach((item) {
        int mId = item['mId'];
        String userId = item['UserId'];
        int discussionId = item['discussionId'];
        String mMessage = item.containsKey('mContent')
            ? item['mContent']
            : 'No Message'; // Assuming mMessage is another field you want to parse
        print("userId: $userId mContent: $mMessage");
      });

      List<Comment> returnData =
          mData.map((item) => Comment.fromJson(item)).toList();
      for (var comment in returnData) {
        print("Userid: ${comment.userId}, Content: ${comment.message}");
      }

      return returnData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Did not receive success status code from request.');
    }
  }
}
