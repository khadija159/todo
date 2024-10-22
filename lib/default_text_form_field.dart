import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget{
  DefaultTextFormField({
    required this.controller,
    required this.hintText,
    required this.validator,
});

  TextEditingController controller;
  String hintText;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: validator,
    );
  }

}