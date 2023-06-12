import '../entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithEmailAndPassword(String email, String password);
  Future<UserEntity?> registerWithEmailAndPassword(
      String email, String password);
}
