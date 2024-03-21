import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//display error to user
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: Text(message),
          ));
}

String? getApiKeyFromEnv(String key) {
  return dotenv.env[key] as String?;
}