import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Stream<UserProfile> call(String userId) {
    return repository.getUser(userId);
  }
}
