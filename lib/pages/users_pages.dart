import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_back_button.dart';
import 'package:social/components/my_list_style.dart';
import 'package:social/utils/utils.dart';

class UsersPages extends StatelessWidget {
  const UsersPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50, left: 25),
                child: Row(
                  children: [
                    MyBackButton(),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    //get individual user
                    final user = users[index];

                    String username = user['username'];
                    String email = user['email'];
                    return MyListStyle(
                        title: username, subTitle: email);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
