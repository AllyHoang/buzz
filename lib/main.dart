import 'dart:convert';
import 'package:dawgs/CommentPage.dart';
import 'package:dawgs/MainUserProfile.dart';
import 'package:dawgs/LightUserProfile.dart';
import 'package:dawgs/models/Discussion.dart';
import 'package:dawgs/models/UserProfile.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dawgs/components/text_field.dart';
import 'dart:developer' as developer;
import 'package:dawgs/net/WebRequests.dart';
//New Import
import 'package:google_sign_in/google_sign_in.dart';
import 'login_page.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

void main() {
  runApp(MyApp()); // Pass the HTTP client to MyApp
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Constructor

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Buzz',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 32, 7, 80)),
        useMaterial3: true,
      ),
      home: LoginPage(), // Changed to LoginPage as the home screen
      routes: {
        '/discussions': (context) => Builder(
              builder: (BuildContext context) {
                // Retrieve the userId from the current context
                String? userId =
                    ModalRoute.of(context)?.settings.arguments as String?;
                return MyHomePage(
                    title: 'Home Page',
                    userId: userId ?? ''); // Pass the userId to MyHomePage
              },
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title, required this.userId});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  String? userId;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  final messageController = TextEditingController();
  late Future<List<Discussion>> _future_list_discussions;
  late Color _upvoteColor = Colors.grey; // Initialize with default color
  late Color _downvoteColor = Colors.grey; // Initialize with default color
  late Map<int, List<bool>> _voteStatusMap;

  @override
  void initState() {
    super.initState();
    _future_list_discussions = fetchDiscussions();
    _voteStatusMap = {};
  }

  @override
  Widget build(BuildContext context) {
    return build_v3(context);
  }

  Widget build_v3(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Discussion>>(
              future: _future_list_discussions,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Discussion>> snapshot) {
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
                } else if (snapshot.hasData) {
                  // Filter out invalid discussions
                  final validDiscussions = snapshot.data!
                      .where((discussion) => (discussion.inValid == false))
                      .toList();

                  if (validDiscussions.isEmpty) {
                    // No valid discussions to display
                    return Center(
                      child: Text(
                        'No valid discussions available',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: validDiscussions.length,
                    itemBuilder: (context, index) {
                      final discussion = validDiscussions[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  // Navigate to user profile page
                                },
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      child: Icon(
                                        Icons.account_circle,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      discussion.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                discussion.message,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      // Add functionality for upvote icon
                                    },
                                    icon: Icon(
                                      Icons.thumb_up,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Add functionality for downvote icon
                                    },
                                    icon: Icon(
                                      Icons.thumb_down,
                                      size: 20,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Add functionality for comment icon
                                    },
                                    icon: Icon(
                                      Icons.comment,
                                      size: 20,
                                    ),
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
                  // Display a message when no data is available
                  return Center(
                    child: Text(
                      'No data available',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }
              },
            ),
          ),
          // Post Discussion Section
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: titleController,
                    hintText: 'Title now!',
                    obscureText: false,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: MyTextField(
                    controller: messageController,
                    hintText: 'Content please',
                    obscureText: false,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _future_list_discussions = postDiscussion(
                          titleController.text,
                          messageController.text,
                          widget.userId);
                    });
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

  Future<void> _checkBoolStatus(int discussionId) async {
    List<bool> voteStatus = await _getVoteStatus(discussionId);
    bool uvote = voteStatus[0];
    bool dvote = voteStatus[1];
    _initializeColors(uvote, dvote, discussionId);
  }

  Future<List<bool>> _getVoteStatus(int discussionId) async {
    bool uvote = await checkUpVote(discussionId);
    bool dvote = await checkDownVote(discussionId);
    return [uvote, dvote];
  }

  void _initializeColors(bool uvote, bool dvote, int discussionId) {
    setState(() {
      _voteStatusMap[discussionId] = [uvote, dvote];
    });
  }

  Color _getUpvoteColor(int discussionId) {
    // Get the vote status from the map, default to grey if not found
    final voteStatus = _voteStatusMap[discussionId] ?? [false, false];
    return voteStatus[0] ? Colors.blue : Colors.grey;
  }

  Color _getDownvoteColor(int discussionId) {
    // Get the vote status from the map, default to grey if not found
    final voteStatus = _voteStatusMap[discussionId] ?? [false, false];
    return voteStatus[1] ? Colors.red : Colors.grey;
  }
}
