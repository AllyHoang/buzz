import 'package:flutter/material.dart';
import 'package:dawgs/login_page.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import your login page

final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class ErrorPage extends StatelessWidget {
  void _handleSignOut(BuildContext context) async {
    // Implement sign-out functionality
    try {
      // Perform sign-out action
      // You need to replace _googleSignIn with your GoogleSignIn instance
      // and LoginPage() with your actual login page widget
      await _googleSignIn.signOut();
      print('User signed out.');
      Navigator.pushReplacement(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You are not able to log in due to bad activity.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add functionality to contact services
              },
              child: Text('Contact Our Services'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call the _handleSignOut method to perform sign-out
                _handleSignOut(context);
              },
              child: Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
