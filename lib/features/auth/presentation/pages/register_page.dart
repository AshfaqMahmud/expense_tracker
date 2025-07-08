import 'package:expense_tracker/core/widgets/frosted_tf.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _confirmPasswordController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 100.0),
              Text(
                'Register',
                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30.0),
              FrostedTextField(
                label: 'Username',
                controller: _userNameController,
              ),
              SizedBox(height: 16.0),
              FrostedTextField(label: 'Email', controller: _emailController),
              SizedBox(height: 16.0),
              FrostedTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              FrostedTextField(
                label: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle registration
                    print('Username: ${_userNameController.text}');
                    print('Email: ${_emailController.text}');
                    print('Password: ${_passwordController.text}');
                    print(
                      'Confirm Password: ${_confirmPasswordController.text}',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B62FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
