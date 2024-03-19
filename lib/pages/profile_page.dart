import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social/components/my_back_button.dart';
import 'package:social/components/my_list_style.dart';
import 'package:social/database/firestore.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //firestore access
  final FirebasestoreDatabase database = FirebasestoreDatabase();

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
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 50, left: 25),
                      child: Row(
                        children: [
                          MyBackButton(),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.all(25),
                      child: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        size: 64,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      userData!['username'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      userData['email'],
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),

                    //return as a list
                    StreamBuilder(
                      stream: database.getMyPostsStream(),
                      builder: (context, snapshot) {
                        //show loading circle
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Verify data availability
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Center(
                            child: Text('No posts available.'),
                          );
                        }
                        // get all posts
                        final posts = snapshot.data!.docs;

                        //no data?
                        if (snapshot.data == null || posts.isEmpty) {
                          return Center(
                            child: Padding(
                                padding: const EdgeInsets.all(25),
                                child: Text(
                                  "No posts yet... Be the first to post!",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary),
                                )),
                          );
                        }

                        //return as a list
                        return Expanded(
                          child: ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              //get individual post
                              final post = posts[index];

                              String message = post['message'];
                              String userEmail = post['email'];
                              Timestamp timestamp = post['timestamp'];

                              return MyListStyle(
                                  title: message,
                                  subTitle: userEmail,
                                  timeStamp: timestamp);
                            },
                          ),
                        );
                      },
                    )
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
