import 'dart:convert';
import 'package:dawgs/login_page.dart';
import 'package:dawgs/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:dawgs/models/LightUserProfile.dart'; // Import LightUserProfile model
import 'package:flutter/material.dart';

class LightUserProfilePage extends StatefulWidget {
  LightUserProfilePage({Key? key, required this.userId}) : super(key: key);

  final String? userId;

  @override
  _LightUserProfilePageState createState() => _LightUserProfilePageState();
}

class _LightUserProfilePageState extends State<LightUserProfilePage> {
  late Future<LightUserProfile> _futureUserProfile;

  @override
  void initState() {
    super.initState();
    _futureUserProfile = fetchUserProfile(widget.userId); // Pass userId here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyHomePage(title: 'Home Page', userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<LightUserProfile>(
          future: _futureUserProfile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(snapshot.data!.pictureUrl),
                  SizedBox(height: 20),
                  Text('Name: ${snapshot.data!.name}'),
                  Text('Username: ${snapshot.data!.username ?? 'N/A'}'),
                  Text(
                      'Email: ${snapshot.data!.email ?? 'N/A'}'), // Handle nullable field
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<LightUserProfile> fetchUserProfile(String? userId) async {
    final response = await http.get(
        Uri.parse('https://team-dawgs.dokku.cse.lehigh.edu/users/$userId'));
    if (response.statusCode == 200) {
      // If the server returned a 200 OK response, parse the JSON.
      var jsonData = jsonDecode(response.body);
      print('json decode: $jsonData'); // Print decoded JSON data

      Map<String, dynamic> mData = jsonData['mData'];

      // Extract fields from the JSON data
      int mId = mData['mId'] ?? 0; // Provide default value if null
      String userId = mData['UserId'] ?? '';
      String pictureUrl = mData['pictureUrl'] ?? '';
      String email = mData['email'] ?? '';
      bool inValid = mData['inValid'] ?? false;
      String name = mData['name'] ?? '';
      String username = mData['username'] ?? '';
      String gender = mData['gender'] ?? '';
      String sexualOrientation = mData['sexualOrientation'] ?? '';
      String note = mData['note'] ?? '';

      // Create a LightUserProfile object with the extracted data
      LightUserProfile userProfile = LightUserProfile(
        id: mId,
        userId: userId,
        pictureUrl: pictureUrl,
        email: email,
        inValid: inValid,
        name: name,
        username: username,
        gender: gender,
        sexualOrientation: sexualOrientation,
        note: note,
      );

      // Return the created LightUserProfile object
      return userProfile;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to fetch user profile: ${response.statusCode}');
    }
  }
}
