import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/login_cubit.dart';
import '../../domain/login_state.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true; // State variable to manage password visibility

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is LoginFailure) {
          _showErrorDialog(state.error ?? "Login failed.");
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool isFullScreen = constraints.maxWidth > 1000;

              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Logo at the top
                              SizedBox(
                                height: 23,
                              ),

                              Text(
                                'English (UK)',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(height: 50),
                              Image.asset(
                                'assets/insta_logo.png', // Replace with your logo image
                                height: isFullScreen
                                    ? 64
                                    : 48, // Adjust height based on screen size
                                width: isFullScreen
                                    ? 498
                                    : 300, // Adjust width based on screen size
                              ),
                              const SizedBox(height: 40),
                              // Username TextField
                              _buildTextField(
                                controller: _usernameController,
                                labelText: 'Email address',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // Password TextField with hide/unhide toggle
                              _buildPasswordField(
                                controller: _passwordController,
                                labelText: 'Password',
                                obscureText: _obscurePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),
                              // Login Button
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    final username = _usernameController.text;
                                    final password = _passwordController.text;
                                    context
                                        .read<LoginCubit>()
                                        .login(username, password);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 131, 33, 243),
                                  minimumSize: const Size(double.infinity, 50),

                                  // elevation: 0,
                                ),
                                child: const Text(
                                  'Log In',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),
                              // Forgot Password Option
                              TextButton(
                                onPressed: () {
                                  // Navigate to Forgot Password page or other action
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 150,
                              ),
                              SizedBox(
                                width: 300, // Same width as the first button
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupScreen()),
                                    );
                                  },
                                  child: const Text(
                                    'Create new account',
                                    style: TextStyle(
                                      fontWeight: FontWeight
                                          .bold, // Makes the text bold
                                      color: Color.fromARGB(255, 131, 33,
                                          243), // Set the text color
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 131, 33,
                                          243), // Set the border color
                                      width: 2, // Set the border width
                                    ),
                                    minimumSize: Size(
                                        double.infinity, 40), // Button height
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                child: Image.asset(
                                  'assets/meta.png',
                                  width: 70,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      validator: validator,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: labelText,
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      ),
      obscureText: obscureText,
      validator: validator,
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
