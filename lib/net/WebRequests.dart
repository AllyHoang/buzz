import 'package:http/http.dart' as http;
import 'package:dawgs/models/Discussion.dart';
import 'dart:convert';

/// Posts a discussion with the given [title] and [message] to the server.
///
/// Returns a list of [Discussion] objects containing the posted discussion.
///
/// Throws an [Exception] if posting the discussion fails.
Future<List<Discussion>> postDiscussion(
    String title, String message, String? userId) async {
  try {
    final response = await http.post(
      Uri.parse('https://team-dawgs.dokku.cse.lehigh.edu/discussions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': userId,
        'mTitle': title,
        'mMessage': message,
      }),
    );

    if (response.statusCode == 200) {
      // Construct a list with a single discussion object
      final discussion = getDiscussionFromResponse(response);
      return [discussion];
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

Future<void> upVote(int discussionId) async {
  try {
    final response = await http.put(
      Uri.parse(
          'https://team-dawgs.dokku.cse.lehigh.edu/discussions/$discussionId/upVote'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Downvote successful
      print('Discussion $discussionId upvoted successfully.');
    } else {
      // Handle other status codes if needed
      print('Failed to downvote discussion $discussionId');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Failed to downvote discussion $discussionId: $error');
  }
}

Future<void> downVote(int discussionId) async {
  try {
    final response = await http.put(
      Uri.parse(
          'https://team-dawgs.dokku.cse.lehigh.edu/discussions/$discussionId/downVote'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // Downvote successful
      print('Discussion $discussionId upvoted successfully.');
    } else {
      // Handle other status codes if needed
      print('Failed to downvote discussion $discussionId');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (error) {
    print('Failed to downvote discussion $discussionId: $error');
  }
}

Future<bool> checkUpVote(int discussionId) async {
  final String url =
      'https://team-dawgs.dokku.cse.lehigh.edu/discussions/$discussionId/upVote';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the response JSON
      final responseData = jsonDecode(response.body);
      // Extract the result from the JSON
      final bool result = responseData['mData'];
      // Return the result
      return result;
    } else {
      // Handle other status codes if needed
      throw Exception(
          'Failed to check upvote for discussion $discussionId. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception(
        'Failed to check upvote for discussion $discussionId: $error');
  }
}

Future<bool> checkDownVote(int discussionId) async {
  final String url =
      'https://team-dawgs.dokku.cse.lehigh.edu/discussions/$discussionId/downVote';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Parse the response JSON
      final responseData = jsonDecode(response.body);
      // Extract the result from the JSON
      final bool result = responseData['mData'];
      // Return the result
      return result;
    } else {
      // Handle other status codes if needed
      throw Exception(
          'Failed to check upvote for discussion $discussionId. Status code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception(
        'Failed to check upvote for discussion $discussionId: $error');
  }
}

/// Parses the discussion object from the HTTP [response].
///
/// Returns a [Discussion] object parsed from the response data.
///
/// Throws an [Exception] if parsing fails.
Discussion getDiscussionFromResponse(http.Response response) {
  try {
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    final discussion = Discussion.fromJson(responseData);
    return discussion;
  } catch (e) {
    print('Error parsing discussion from response: $e');
    throw Exception('Failed to parse discussion from response.');
  }
}

Future<bool> checkDiscussionInvalid(int id) async {
  try {
    final response = await http.get(
      Uri.parse(
          'https://team-dawgs.dokku.cse.lehigh.edu/discussions/$id/checkInvalid'),
    );
    if (response.statusCode == 200) {
      // Parse the response JSON
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      // Extract the result value
      bool result = jsonData['mData'];
      return result;
    } else {
      // Handle error response
      print(
          'Failed to check discussion invalid status. Status code: ${response.statusCode}');
      return false; // Or throw an exception
    }
  } catch (error) {
    // Handle network or other errors
    print('Error checking discussion invalid status: $error');
    return false; // Or throw an exception
  }
}

/// Fetches discussions from the server.
///
/// Returns a list of [Discussion] objects fetched from the server.
///
/// Throws an [Exception] if the server does not return a success status code.
Future<List<Discussion>> fetchDiscussions() async {
  final response = await http
      .get(Uri.parse('https://team-dawgs.dokku.cse.lehigh.edu/discussions'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response, then parse the JSON.
    var res = jsonDecode(response.body);
    print('json decode: $res'); // Print decoded JSON data

    List<dynamic> mData = res['mData'];
    mData.forEach((item) {
      int mId = item['mId'];
      String mTitle = item['mTitle'];
      String userId = item.containsKey('userId') ? item['userId'] : "";
      String mMessage = item.containsKey('mContent')
          ? item['mContent']
          : 'No Message'; // Assuming mMessage is another field you want to parse
      bool inValid = item['inValid'];
      print("mTitle: $mTitle mContent: $mMessage");
    });

    List<Discussion> returnData =
        mData.map((item) => Discussion.fromJson(item)).toList();
    for (var discussion in returnData) {
      print("Title: ${discussion.title}, Content: ${discussion.message}");
    }

    return returnData;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Did not receive success status code from request.');
  }
}
