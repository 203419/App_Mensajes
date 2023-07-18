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
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF2C3C4D),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                Text('Bienvenido',
                    style: TextStyle(fontSize: 27, color: Colors.white)),
                const SizedBox(height: 60),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Correo electrónico',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 186, 179, 179),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      labelText: 'Contraseña',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(255, 186, 179, 179),
                        fontSize: 14,
                      ),
                      suffixIcon: Icon(
                        Icons.visibility,
                        color: Color.fromARGB(255, 186, 179, 179),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.0),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 0),
                  child: ElevatedButton(
                    onPressed: _signIn,
                    child: Text('Sign In',
                        style: TextStyle(fontSize: 17, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF31D843),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: Text('No tienes cuenta? Regístrate aquí'),
                ),
                SizedBox(height: 360),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
