import 'package:firebase_auth/firebase_auth.dart';
import '../datasources/auth_datasource.dart';
import 'package:app_auth/features/user/domain/repositories/auth_repository.dart';
import 'package:app_auth/features/user/domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({required this.dataSource});

  @override
  Future<UserEntity?> signInWithEmailAndPassword(
      String? email, String? password) async {
    final signInEmail = email ?? '';
    final signInPassword = password ?? '';

    final user = await dataSource.signInWithEmailAndPassword(
        signInEmail, signInPassword);
    if (user != null) {
      return UserEntity(id: user.uid, email: user.email);
    }
    return null;
  }

  @override
  Future<UserEntity?> registerWithEmailAndPassword(
      String? email, String? password) async {
    final registerEmail = email ?? '';
    final registerPassword = password ?? '';

    final user = await dataSource.registerWithEmailAndPassword(
        registerEmail, registerPassword);
    if (user != null) {
      return UserEntity(id: user.uid, email: user.email);
    }
    return null;
  }
}
