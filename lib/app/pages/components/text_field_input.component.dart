import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController firstNum;
  final String text;
  TextFieldInput({
    required this.firstNum,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: firstNum,
      decoration: InputDecoration(
        labelText: text,
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null ||
            value.isEmpty ||
            double.tryParse(value) == null) {
          return 'Please enter a valid value';
        }
        return null;
      },
    );
  }
}