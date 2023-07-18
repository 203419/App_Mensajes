import 'package:app_auth/features/profile/data/datasources/firebase_user_datasource.dart';
import 'package:app_auth/features/profile/domain/entities/user.dart';
import 'package:app_auth/features/profile/domain/repositories/user_repository.dart';
import 'package:app_auth/features/profile/data/models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserDataSource dataSource;

  UserRepositoryImpl(this.dataSource);

  @override
  Stream<UserProfile> getUser(String userId) {
    return dataSource.getUser(userId).map((userModel) => userModel.toDomain());
  }

  @override
  Future<void> updateUser(String userId, UserProfile user) async {
    final userModel = UserModel(
      imageProfileUrl: user.imageProfileUrl,
      username: user.username,
      userId: user.userId,
    );
    await dataSource.updateUser(userId, userModel);
  }

  @override
  Future<String> uploadProfileImage(String userId) async {
    return await dataSource.uploadProfileImage(userId);
  }
}
