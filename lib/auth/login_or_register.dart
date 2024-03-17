import 'package:flutter/material.dart';
import 'package:social/pages/login_page.dart';
import 'package:social/pages/register_page.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({ Key? key }) : super(key: key);

  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  
  //initialy, show login page
  bool showLogin = true;

  //toggle between login and register page
  void toggle() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogin) {
      return LoginPage(onTap: toggle);
    } else {
      return RegisterPage(onTap: toggle);
    }
  }
}