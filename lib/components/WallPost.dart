import 'package:flutter/material.dart';

class WallPost extends StatelessWidget {
  final String title;
  final String message;

  const WallPost({super.key, required this.title, required this.message});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.black)),
              const SizedBox(height: 10),
              Text(message, style: TextStyle(color: Colors.black)),
            ],
          )
        ],
      ),
    );
  }
}
