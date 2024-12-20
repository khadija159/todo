import 'package:flutter/material.dart';

class DefaultTextFormField extends StatefulWidget {
  DefaultTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
    this.isPassword = false,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPassword;

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  late bool isObscure;

  @override
  void initState() {
    super.initState();
    isObscure = widget.isPassword; // Initialize isObscure based on isPassword
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: isObscure, // Ensure text is obscured when isObscure is true
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () {
            setState(() {
              isObscure = !isObscure; // Toggle the obscure state
            });
          },
          icon: Icon(
            isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        )
            : null,
      ),
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
