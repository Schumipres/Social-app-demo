import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/utils/utils.dart';

class UsersPages extends StatelessWidget {
  const UsersPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Users Page"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: ((context, snapshot) {
          //any errors
          if (snapshot.hasError) {
            displayMessageToUser("Something went wrong", context);
          }

          //show loading circle
          else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          //get all users
          final users = snapshot.data!.docs;

          //return user details
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              //get individual user
              final user = users[index];
              return ListTile(
                title: Text(user['username']),
                subtitle: Text(user['email']),
              );
            },
          );
        }),
      ),
    );
  }
}
