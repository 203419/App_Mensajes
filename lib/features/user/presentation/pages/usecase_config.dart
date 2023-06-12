import 'package:app_auth/features/user/data/datasources/auth_datasource.dart';
import 'package:app_auth/features/user/data/repositories/auth_repository.dart';
import 'package:app_auth/features/user/domain/usecases/auth_usecase.dart';

class UseCaseConfigUser {
  SignInWithEmailAndPasswordUseCase? signInUseCase;
  RegisterWithEmailAndPasswordUseCase? registerUseCase;
  AuthRepositoryImpl? authRepository;
  AuthDataSource? authDataSource;

  UseCaseConfigUser(this.authDataSource) {
    authRepository = AuthRepositoryImpl(dataSource: authDataSource!);
    signInUseCase =
        SignInWithEmailAndPasswordUseCase(repository: authRepository!);
    registerUseCase =
        RegisterWithEmailAndPasswordUseCase(repository: authRepository!);
  }
}
