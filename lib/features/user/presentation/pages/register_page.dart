import 'package:flutter/material.dart';
import 'package:app_auth/features/user/domain/usecases/auth_usecase.dart';

class RegisterPage extends StatefulWidget {
  final RegisterWithEmailAndPasswordUseCase registerUseCase;

  const RegisterPage({required this.registerUseCase});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await widget.registerUseCase.call(email, password);

    if (user != null) {
      Navigator.of(context).pushNamed('/chat');
    } else {
      print('error al registrar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
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
              onPressed: _register,
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
