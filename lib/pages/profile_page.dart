import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //future to fetch user data
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    //fetch user details
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          "Profile Page",
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            //loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            //error
            else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }

            //data recieved
            else if (snapshot.hasData) {
              //extract data
              Map<String, dynamic>? userData = snapshot.data!.data();

              //return user details
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Username: ${userData!['username']}"),
                    Text("Email: ${userData['email']}"),
                  ],
                ),
              );
            }

            //default
            else {
              return const Center(
                child: Text("Error fetching user data"),
              );
            }
          }),
    );
  }
}
