import 'package:dawgs/ErrorPage.dart';
import 'package:dawgs/MainUserProfile.dart';
import 'package:dawgs/main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import json library

class LoginPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _handleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await account.authentication;
        String? idToken = googleSignInAuthentication.idToken;
        print(idToken);
        String? userId = await sendRequestToServer(idToken);
        if (userId == null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ErrorPage(),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainUserProfile(userId: userId),
            ),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign in failed: $error'),
        ),
      );
    }
  }

  Future<String?> sendRequestToServer(String? idToken) async {
    var url = Uri.parse('https://team-dawgs.dokku.cse.lehigh.edu/tokensignin');
    var headers = {'Content-Type': 'application/json'};
    var body = idToken;
    try {
      var response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        // Parse the response body
        var responseData = json.decode(response.body);
        print("Server response: $responseData");
        // Check if the response contains the user ID
        if (responseData.containsKey('userId')) {
          // Return the user ID
          return responseData['userId'];
        } else {
          print("User ID not found in the server response.");
          // Handle the case where the user ID is not found in the response
          return null;
        }
      } else {
        // Handle server errors or invalid responses
        print("Server returned an error: ${response.body}");
        return null;
      }
    } catch (error) {
      print("Error sending access token to server: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleSignIn(context),
          child: Text('Sign in with Google'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
      ),
    );
  }
}
