import 'package:flutter/material.dart';

class ErrorTextBox extends StatelessWidget {
  final String message;
  const ErrorTextBox({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      return Text(message, style: TextStyle(color: Colors.red));
    } else {
      return SizedBox(height: 0, width: 0);
    }
  }
}
