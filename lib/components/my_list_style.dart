import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyListStyle extends StatelessWidget {
  final String title;
  final String subTitle;
  final Timestamp? timeStamp;

  const MyListStyle(
      {super.key, required this.title, required this.subTitle, this.timeStamp});

  // convert timestamp to date to string
  String convertTimeStampToDate(Timestamp timeStamp) {
    DateTime date = timeStamp.toDate();
    return "${date.year}/${date.month}/${date.day}";
  }

  // prepare subtitle email + date if date is not null else just email
  String prepareSubTitle(String email, Timestamp? timeStamp) {
    // if time stamp exists then return email + date else just email
    if (timeStamp != null) {
      return "$email - ${convertTimeStampToDate(timeStamp)}";
    } else {
      return email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 2),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(2),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            prepareSubTitle(subTitle, timeStamp),
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ),
    );
  }
}
