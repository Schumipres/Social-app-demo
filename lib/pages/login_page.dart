import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:social/components/my_button.dart';
import 'package:social/components/my_textfield.dart';
import 'package:social/utils/utils.dart';

class LoginPage extends StatefulWidget {

  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //login method
  void login() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    //try signing in
    try {
      //sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      //pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      //pop loading circle
      Navigator.pop(context);
      //show error message
      displayMessageToUser(e.message!, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.person,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 25),

              //app name
              const Text(
                "M I N I M A L",
                style: TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 50),

              //email text input
              MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController),

              const SizedBox(height: 10),

              //password text input
              MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController),
              const SizedBox(height: 10),

              //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Forgot password?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      )),
                ],
              ),
              const SizedBox(height: 25),

              //sign in button
              MyButton(text: "Login", onTap: login),
              const SizedBox(height: 25),

              //don't have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      )),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(" Register Here",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
