import 'dart:convert';
import 'package:dawgs/login_page.dart';
import 'package:dawgs/main.dart';
import 'package:dawgs/EditProfilePage.dart'; // Import EditProfilePage
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:dawgs/models/UserProfile.dart';
import 'package:flutter/material.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class MainUserProfile extends StatefulWidget {
  MainUserProfile({Key? key, required this.userId}) : super(key: key);

  final String? userId;

  @override
  _MainUserProfileState createState() => _MainUserProfileState();
}

class _MainUserProfileState extends State<MainUserProfile> {
  late Future<UserProfile> _futureUserProfile;

  @override
  void initState() {
    super.initState();
    _futureUserProfile = fetchUserProfile(widget.userId); // Pass userId here
  }

  void _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
      print('User signed out.');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
      // TODO: reset the user state in the app
    } catch (error) {
      print('Sign out error: $error');
    }
  }

  void _handleEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(userId: widget.userId),
      ),
    );
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
          IconButton(
            icon: Icon(Icons.edit),
            onPressed:
                _handleEditProfile, // Call function to navigate to EditProfilePage
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<UserProfile>(
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
                  Text(
                      'Username: ${snapshot.data!.username ?? 'N/A'}'), // Handle nullable field
                  Text('Gender: ${snapshot.data!.gender}'),
                  Text('Sexual Identity: ${snapshot.data!.sexualOrientation}'),
                  Text('Note: ${snapshot.data!.note}'),
                  ElevatedButton(
                    onPressed: _handleSignOut,
                    child: const Text('Sign out of Google'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<UserProfile> fetchUserProfile(String? userId) async {
    final response = await http.get(
        Uri.parse('https://team-dawgs.dokku.cse.lehigh.edu/users/$userId'));
    print('https://team-dawgs.dokku.cse.lehigh.edu/users/$userId');
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

      // Create a UserProfile object with the extracted data
      UserProfile userProfile = UserProfile(
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
      print(userProfile);

      // Return the created UserProfile object
      return userProfile;
    } else {
      // If the server did not return a 200 OK response,
      // throw an exception.
      throw Exception('Failed to fetch user profile: ${response.statusCode}');
    }
  }
}
