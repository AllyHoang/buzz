class LightUserProfile {
  final int id;
  final String userId;
  final String pictureUrl;
  final String email;
  final bool inValid;
  final String name;
  final String username;
  final String gender;
  final String sexualOrientation;
  final String note;

  LightUserProfile({
    required this.id,
    required this.userId,
    required this.pictureUrl,
    required this.email,
    required this.inValid,
    required this.name,
    required this.username,
    required this.gender,
    required this.sexualOrientation,
    required this.note,
  });

  factory LightUserProfile.fromJson(Map<String, dynamic> json) {
    return LightUserProfile(
      id: json['mId'] ??
          0 as int, // Provide a default value if 'mId' is missing
      userId: json['UserId'] ??
          '', // Provide a default value if 'UserId' is missing
      pictureUrl: json['pictureUrl'] ??
          '', // Provide a default value if 'pictureUrl' is missing
      email:
          json['email'] ?? '', // Provide a default value if 'email' is missing
      inValid: json['inValid'] ??
          false, // Provide a default value if 'inValid' is missing
      name: json['name'] ?? '', // Provide a default value if 'name' is missing
      username: json['username'], // Nullable field, no need for default value
      gender: json['gender'] ??
          '', // Provide a default value if 'gender' is missing
      sexualOrientation: json['sexualOrientation'] ??
          '', // Provide a default value if 'sexualOrientation' is missing
      note: json['note'] ?? '', // Provide a default value if 'note' is missing
    );
  }
}
