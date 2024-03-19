/*

This database is used to store the post that user's have published.
it is stored in a collection called 'Posts' in firesbase

Each post containes:
- message
- email of user
- timestamp

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebasestoreDatabase {
  // current logged in user
  User? currentUser = FirebaseAuth.instance.currentUser;

  //get collection of posts from firebase
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');

  //post a message
  Future<void> addPost(String message) async {
    //add post to database
    await posts.add({
      'message': message,
      'email': currentUser!.email,
      'timestamp': FieldValue.serverTimestamp(),
      'userUid': currentUser!.uid,
    });
  }

  //read posts from database
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('timestamp', descending: true)
        .snapshots();
        
    return postsStream;
  }

  //read post from database only of current user by userUid
  Stream<QuerySnapshot> getMyPostsStream() {
    print(currentUser!.uid);
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .where('userUid', isEqualTo: currentUser!.uid)
        .orderBy('timestamp', descending: true)
        .snapshots();
    return postsStream;
  }
}
