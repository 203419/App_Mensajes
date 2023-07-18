import 'package:app_auth/features/profile/domain/entities/user.dart';

class UserModel {
  final String imageProfileUrl;
  final String username;
  final String userId;

  UserModel({
    required this.imageProfileUrl,
    required this.username,
    required this.userId,
  });

  UserProfile toDomain() {
    return UserProfile(
      imageProfileUrl: imageProfileUrl,
      username: username,
      userId: userId,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      imageProfileUrl: data['imageUrl'] ?? '',
      username: data['username'] ?? '',
      userId: data['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageProfileUrl,
      'username': username,
      'userId': userId,
    };
  }
}
