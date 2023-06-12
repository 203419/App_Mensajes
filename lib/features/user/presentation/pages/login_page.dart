import 'package:flutter/material.dart';
import 'package:app_auth/features/user/domain/usecases/auth_usecase.dart';

class LoginPage extends StatefulWidget {
  final SignInWithEmailAndPasswordUseCase signInUseCase;

  const LoginPage({required this.signInUseCase});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await widget.signInUseCase.call(email, password);

    if (user != null) {
      // Navegar a /chat
      Navigator.of(context).pushNamed('/chat');
    } else {
      // Mostrar mensaje de error
      print('error al iniciar sesión');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              child: Text('No tienes cuenta? Regístrate aquí'),
            ),
          ],
        ),
      ),
    );
  }
}
