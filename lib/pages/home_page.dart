import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:social/components/my_drawer.dart';
import 'package:social/components/my_list_style.dart';
import 'package:social/components/my_post_button.dart';
import 'package:social/components/my_textfield.dart';
import 'package:social/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //firestore access
  final FirebasestoreDatabase database = FirebasestoreDatabase();

  //Text controller newPost
  final TextEditingController newPostController = TextEditingController();

  // post message
  void postMessage() {
    //only post message if it's not empty
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
    }

    //clear textfield
    newPostController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "wall",
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          //new post
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextfield(
                            hintText: "What's on your mind?",
                            obscureText: false,
                            controller: newPostController),
                      ),
                      MyPostButton(onTap: postMessage),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // POSTS LIST
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              //show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
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
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
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
                    Timestamp? timestamp = post['timestamp'];

                    return MyListStyle(title: message, subTitle: userEmail, timeStamp: timestamp);
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
