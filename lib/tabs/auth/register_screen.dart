import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_functions.dart';
import 'package:todo/home_screen.dart';
import 'package:todo/tabs/auth/user_provider.dart';

import '../../default_elevated_button.dart';
import '../../default_text_form_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget{
  static const String routeName = '/register';

  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreen();

}

class _RegisterScreen extends State<RegisterScreen>{
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DefaultTextFormField(
                controller: nameController,
                hintText: 'Name',
                validator: (value){
                  if(value == null || value.trim().length<3){
                    return'Name must be more than 2 characters';
                  }
                  else{
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: emailController,
                hintText: 'Email',
                validator: (value){
                  if(value == null || value.trim().length<5){
                    return'Email must be more than 5 characters';
                  }
                  else{
                    return null;
                  }
                },
              ),
              const SizedBox(height: 16),
              DefaultTextFormField(
                controller: passwordController,
                hintText: 'Password',
                validator: (value){
                  if(value == null || value.trim().length<8){
                    return"Password can't be less than 8 characters";
                  }
                  else{
                    return null;
                  }
                },
                isPassword: true,
              ),
              const SizedBox(height: 32),
              DefaultElevatedButton(
                label: 'Register',
                onPressed: Register,
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(LoginScreen.routeName),
                  child: const Text("Already have an account"))
            ],
          ),
        ),
      ),
    );
  }
  void Register(){
    if(formKey.currentState!.validate()){
      FirebaseFunctions.register(
          name: nameController.text,
          email: emailController.text,
          password: passwordController.text
      ).then(
            (user){
        Provider.of<UserProvider>(context, listen: false).updateUser(user);
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
       },
      ).catchError(
            (error) {
        String? message;
        if(error is FirebaseAuthException){
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