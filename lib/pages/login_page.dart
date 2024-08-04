import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/my_textfield.dart';
import '../components/my_button.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();

  Future<void> _signUp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);

    Navigator.pushReplacementNamed(context, '/homePage');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
                controller: _usernameController,
                hintText: 'Username',
                obscureText: true,
            ),
            const SizedBox(height: 20),
            MyButton_SignUp(
              onTap: _signUp,
            ),
          ],
        ),
      ),
    );
  }
}
