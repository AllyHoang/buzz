/// A class representing a discussion.
class Comment {
  /// The unique identifier for the discussion.
  final int id;
  final int discussionId;

  /// The title of the discussion.
  final String userId;

  /// The message content of the discussion.
  final String message;

  Comment({
    required this.id,
    required this.discussionId,
    required this.userId,
    required this.message,
  });

  /// Factory constructor to create a [Discussion] object from JSON data.
  ///
  /// The [json] parameter contains the JSON data to parse.
  ///
  /// Returns a [Discussion] object parsed from the JSON data.
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        // Set default value if null
        id: json['mId'] as int,
        userId: json['UserId'] as String? ?? '',
        discussionId: json['discussionId'] as int,
        message: json['mContent'] as String? ?? '');
  }
}
