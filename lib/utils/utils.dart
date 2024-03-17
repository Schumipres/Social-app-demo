import 'package:flutter/material.dart';

//display error to user
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(message),
          ));
}
