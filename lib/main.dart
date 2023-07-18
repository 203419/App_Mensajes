import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:app_auth/features/user/presentation/pages/login_page.dart';
import 'package:app_auth/features/user/data/datasources/auth_datasource.dart';
import 'package:app_auth/features/user/presentation/pages/usecase_config.dart';
import 'package:app_auth/features/user/presentation/pages/register_page.dart';
import 'package:app_auth/features/chat/presentation/pages/chat_screen.dart';
import 'package:app_auth/features/chat/data/repositories/message_repository_impl.dart';
import 'package:app_auth/features/chat/presentation/usecase_config.dart';
import 'package:app_auth/features/chat/data/datasources/firebase_storage_datasource.dart';
import 'package:app_auth/features/chat/data/datasources/firestore_datasource.dart';
//
import 'package:app_auth/features/profile/data/datasources/firebase_user_datasource.dart';
import 'package:app_auth/features/profile/data/repositories/user_repository_impl.dart';
import 'package:app_auth/features/profile/domain/usecases/get_user_usecase.dart';
import 'package:app_auth/features/profile/domain/usecases/update_user_usecase.dart';
import 'package:app_auth/features/profile/domain/usecases/upload_image_usecase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_auth/features/profile/presentation/profile_screen.dart';

import 'package:app_auth/features/chat/presentation/pages/pdf_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        Provider<GetUserUseCase>(
          create: (_) => GetUserUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firestore: FirebaseFirestore.instance,
                firebaseStorage: FirebaseStorage.instance,
                imagePicker: ImagePicker(),
              ),
            ),
          ),
        ),
        Provider<UpdateUserUseCase>(
          create: (_) => UpdateUserUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firestore: FirebaseFirestore.instance,
                firebaseStorage: FirebaseStorage.instance,
                imagePicker: ImagePicker(),
              ),
            ),
          ),
        ),
        Provider<UploadProfileImageUseCase>(
          create: (_) => UploadProfileImageUseCase(
            UserRepositoryImpl(
              FirebaseUserDataSource(
                firestore: FirebaseFirestore.instance,
                firebaseStorage: FirebaseStorage.instance,
                imagePicker: ImagePicker(),
              ),
            ),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authDataSource =
        FirebaseAuthDataSource(firebaseAuth: FirebaseAuth.instance);
    final useCaseConfigUser = UseCaseConfigUser(authDataSource);

    final UseCaseConfigChat useCaseConfigChat = UseCaseConfigChat(
      FirebaseStorageDataSourceImpl(
        firebaseStorage: FirebaseStorage.instance,
      ),
      FirestoreDataSourceImpl(
        firebaseAuth: FirebaseAuth.instance,
        firebaseFirestore: FirebaseFirestore.instance,
      ),
    );

    // id del usuario logueado
    late String userId = FirebaseAuth.instance.currentUser!.uid;

    return MaterialApp(
      title: 'Mi aplicación',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(
              signInUseCase: useCaseConfigUser.signInUseCase!,
            ),
        '/register': (context) => RegisterPage(
              registerUseCase: useCaseConfigUser.registerUseCase!,
            ),
        '/chat': (context) => ChatScreen(
              useCaseConfig: useCaseConfigChat,
            ),
        '/profile': (context) => UserProfileScreen(
              userId: userId,
            ),
      },
    );
  }
}
