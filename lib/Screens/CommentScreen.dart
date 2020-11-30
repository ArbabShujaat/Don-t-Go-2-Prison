// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Constants/constant.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/stories.dart';
import 'package:flutter/material.dart';
import "dart:async";

import '../Funtions.dart';

// import "main.dart"; //for current user

class CommentScreen extends StatefulWidget {
  final String postId;

  const CommentScreen({
    this.postId,
  });
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool didFetchComments = false;
  String articelId = "";
  int commentsCount;
  List<Comment> fetchedComments = [];

  final TextEditingController _commentController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orange,

        title: Text(
          "Comments",
          style: TextStyle(color: Colors.white),
        ),
        // backgroundColor: Colors.white,
      ),
      body: buildPage(),
    );
  }

  Widget buildPage() {
    return Column(
      children: [
        Expanded(
          child: buildComments(),
        ),
        Divider(),
        ListTile(
          title: TextFormField(
            cursorColor: orange,
            controller: _commentController,
            decoration: InputDecoration(
                labelStyle: TextStyle(color: orange),
                labelText: 'Write a comment...',
                fillColor: orange,
                focusColor: orange),
            onFieldSubmitted: addComment,
          ),
          trailing: OutlineButton(
            onPressed: () {
              addComment(_commentController.text);
            },
            borderSide: BorderSide.none,
            child: Text("Post"),
          ),
        ),
      ],
    );
  }

  Widget buildComments() {
    if (this.didFetchComments == false) {
      return FutureBuilder<List<Comment>>(
          future: getComments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Container(
                  alignment: FractionalOffset.center,
                  child: CircularProgressIndicator());

            this.didFetchComments = true;
            this.fetchedComments = snapshot.data;
            return ListView(
              children: snapshot.data,
            );
          });
    } else {
      // for optimistic updating
      return ListView(children: this.fetchedComments);
    }
  }

  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];
    print(cmntdocid);
    try {
      QuerySnapshot data = await Firestore.instance
          .collection("Posts")
          .document(cmntdocid)
          .collection("Comments")
          .getDocuments();
      data.documents.forEach((DocumentSnapshot doc) {
        comments.add(Comment.fromDocument(doc));
      });
    } catch (e) {
      print(e);
    }
    print("Done");
    return comments;
  }

  addComment(String comment) async {
    _commentController.clear();
    await FirebaseFirestore.instance
        .collection("Posts")
        .document(cmntdocid)
        .collection("Comments")
        .add({
      "userName": userDetails.username,
      "userUid": userDetails.userUid,
      "userImage": userDetails.userpic,
      "userComment": comment
    });

    await FirebaseFirestore.instance
        .collection("Posts")
        .document(cmntdocid)
        .update({"commentsNumber": (int.parse(cmntNumbers) + 1).toString()});
    int cmnts = int.parse(posts[indexcmnt].commentsNumber) + 1;

    posts[indexcmnt].commentsNumber = cmnts.toString();
    setState(() {});

    // add comment to the current listview for an optimistic update
    print(widget.postId);
    setState(() {
      fetchedComments = List.from(fetchedComments)
        ..add(Comment(
            username: userDetails.username,
            comment: comment,
            timestamp: Timestamp.now(),
            avatarUrl: userDetails.userpic,
            userId: userDetails.userUid));
    });
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String avatarUrl;
  final String comment;
  final Timestamp timestamp;

  Comment(
      {this.username,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp});

  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
      username: document['userName'],
      userId: document['userUid'],
      comment: document["userComment"],
      avatarUrl: document["userImage"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 50.0,
              height: 50.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(avatarUrl),
                  )),
            ),
            SizedBox(
              width: 20.0,
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10.0),
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 200,
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                        color: orange,
                        border: Border.all(color: Colors.red),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          comment,
                          style: TextStyle(fontSize: 15, color: Colors.black),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ));
  }
}
