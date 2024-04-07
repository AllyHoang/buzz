import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  final String? userId;

  EditProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _genderController;
  late TextEditingController _sexualOrientationController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _genderController = TextEditingController();
    _sexualOrientationController = TextEditingController();
    _noteController = TextEditingController();
    fetchUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _genderController.dispose();
    _sexualOrientationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void fetchUserProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://team-dawgs.dokku.cse.lehigh.edu/users/${widget.userId}'),
      );
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body)['mData'];
        setState(() {
          _nameController.text = jsonData['name'] ?? '';
          _usernameController.text = jsonData['username'] ?? '';
          _genderController.text = jsonData['gender'] ?? '';
          _sexualOrientationController.text =
              jsonData['sexualOrientation'] ?? '';
          _noteController.text = jsonData['note'] ?? '';
        });
      }
    } catch (error) {
      print('Error fetching user profile: $error');
    }
  }

  Future<void> editProfile(String? userId) async {
    try {
      final response = await http.put(
        Uri.parse(
            'https://team-dawgs.dokku.cse.lehigh.edu/users/$userId/updateProfile'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'name': _nameController.text,
          'username': _usernameController.text,
          'gender': _genderController.text,
          'sexualOrientation': _sexualOrientationController.text,
          'note': _noteController.text,
        }),
      );
      if (response.statusCode == 200) {
        // Handle success response
        print('Profile updated successfully.');
      } else {
        // Handle error response
        print('Failed to update profile. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error updating profile: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => editProfile(widget.userId), // Use a callback here
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            TextField(
              controller: _sexualOrientationController,
              decoration: InputDecoration(labelText: 'Sexual Orientation'),
            ),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'Note'),
            ),
          ],
        ),
      ),
    );
  }
}
