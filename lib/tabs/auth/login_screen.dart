import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/default_elevated_button.dart';
import 'package:todo/default_text_form_field.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/home_screen.dart';
import 'package:todo/tabs/auth/register_screen.dart';
import 'package:todo/tabs/auth/user_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(
                controller: emailController,
                hintText: 'Email',
                validator: (value) {
                  if (value == null || value.trim().length < 5) {
                    return 'Email must be more than 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: passwordController,
                hintText: 'Password',
                validator: (value) {
                  if (value == null || value.trim().length < 8) {
                    return "Password can't be less than 8 characters";
                  }
                  return null;
                },
                isPassword: true, // Ensures the field starts as obscured
              ),
              const SizedBox(height: 32),
              DefaultElevatedButton(
                label: 'Login',
                onPressed: login,
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(RegisterScreen.routeName),
                child: const Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      FirebaseFunctions.login(
        email: emailController.text,
        password: passwordController.text,
      ).then(
            (user) {
          Provider.of<UserProvider>(context, listen: false).updateUser(user);
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        },
      ).catchError(
            (error) {
          String? message;
          if (error is FirebaseAuthException) {
            message = error.message;
          }
          Fluttertoast.showToast(
            msg: message ?? 'Something went wrong',
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.red,
          );
        },
      );
    }
  }
}
