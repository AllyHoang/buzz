/// A class representing a discussion.
class Discussion {
  /// The unique identifier for the discussion.
  final int id;

  /// The title of the discussion.
  final String title;

  /// The message content of the discussion.
  final String message;

  /// Flag indicating whether the discussion is liked.
  final String userId;
  final bool inValid;

  /// Constructs a [Discussion] object.
  ///
  /// The [id], [title], and [message] parameters are required.
  ///
  /// The [isLiked] parameter is optional and defaults to `false`.
  Discussion(
      {required this.id,
      required this.title,
      required this.userId,
      required this.message,
      required this.inValid});

  /// Factory constructor to create a [Discussion] object from JSON data.
  ///
  /// The [json] parameter contains the JSON data to parse.
  ///
  /// Returns a [Discussion] object parsed from the JSON data.
  factory Discussion.fromJson(Map<String, dynamic> json) {
    return Discussion(
      // Set default value if null
      id: json['mId'] as int,
      title: json['mTitle'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      message: json['mContent'] as String? ?? '',
      inValid: json['inValid'] as bool? ?? true, // Set default value if null
    );
  }
}
