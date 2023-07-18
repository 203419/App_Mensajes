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
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFF2C3C4D),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 60),
                const Text('Registro',
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
                    onPressed: _register,
                    child: Text('Sign Up',
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
                    Navigator.of(context).pushNamed('/');
                  },
                  child: Text('Ya tienes cuenta? Inicia sesión'),
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
