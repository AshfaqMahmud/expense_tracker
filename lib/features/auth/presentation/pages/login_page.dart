import 'package:expense_tracker/core/widgets/frosted_tf.dart';
import 'package:expense_tracker/features/auth/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light grey background
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 70.0),
              FrostedTextField(label: 'Email', controller: _userNameController),
              SizedBox(height: 16.0),
              FrostedTextField(
                label: 'Password',
                controller: _passwordController,
                obscureText: true, // Hide password input
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle login
                    print('Email: ${_userNameController.text}');
                    print('Password: ${_passwordController.text}');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B62FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 26),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Forgot Password? ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF87879D)),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add your reset password navigation/function here
                        print('Reset password clicked');
                        //Navigator.push(
                        //context, MaterialPageRoute(builder: (context) => ForgotPass()))
                      },
                      child: Text(
                        'Reset here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue, // Or any color you prefer
                          //decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No account? ',
                      style: TextStyle(fontSize: 14, color: Color(0xFF87879D)),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Add your reset password navigation/function here
                        print('Reset password clicked');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up here',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue, // Or any color you prefer
                          //decoration: TextDecoration.lineT,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
