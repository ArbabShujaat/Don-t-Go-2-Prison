import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/EditPost.dart';
import 'package:design_app/Screens/home.dart';
import 'package:design_app/Screens/stories.dart';
import 'package:flutter/material.dart';

import '../Funtions.dart';

import 'package:intl/intl.dart';

import 'CommentScreen.dart';

List<FetchedPostDetails> postDetails = [];

class PicDetailScreen extends StatefulWidget {
  @override
  _PicDetailScreenState createState() => _PicDetailScreenState();
}

class _PicDetailScreenState extends State<PicDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool _isPressed = false;
    bool _isloading = false;
    return Scaffold(
      appBar: AppBar(
        actions: [
          postDetails[0].postUsername == userDetails.username &&
                  postDetails[0].postUserPic == userDetails.userpic
              ? Row(
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => EditPost()));
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          setState(() {
                            _isloading = true;
                          });
                          await Firestore.instance
                              .collection("Posts")
                              .document(postDetails[0].postid)
                              .delete();
                          print(postDetails[0].postid);
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .document(userDetails.docid)
                              .update({
                            "Posts":
                                (int.parse(userDetails.posts) - 1).toString()
                          });

                          userDetails.posts =
                              (int.parse(userDetails.posts) - 1).toString();
                          setState(() {
                            _isloading = false;
                          });
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                              (Route<dynamic> route) => false);
                        }),
                  ],
                )
              : Container(),
        ],
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Container(
                    color: Colors.white,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          child: ListTile(
                            leading: Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: new NetworkImage(
                                          postDetails[0].postUserPic))),
                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        postDetails[0].postUsername,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    ]),
                                Text(
                                  DateFormat('EEE, M/d/y').format(
                                      DateTime.parse(postDetails[0].time)),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  postDetails[0].postCaption,
                                  style: TextStyle(color: orange, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Image.network(
                        //   posts[index].postPic,
                        // ),

                        CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: postDetails[0].postPic,
                          placeholder: (context, url) => Container(
                              height: 400,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                  child: new CircularProgressIndicator())),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: orange.withOpacity(0.5))),
                          height: 80.0,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: 5.0,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    postDetails[0].likesNumber +
                                        " Likes                                       ",
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.start,
                                  ),
                                  FlatButton.icon(
                                      onPressed: () async {
                                        if (!userDetails.likes
                                            .contains(postDetails[0].postid)) {
                                          await addLike(
                                              postDetails[0].postid,
                                              int.parse(
                                                  postDetails[0].likesNumber));
                                          int likes = int.parse(
                                                  postDetails[0].likesNumber) +
                                              1;
                                          postDetails[0].likesNumber =
                                              likes.toString();
                                          userDetails.likes
                                              .add(postDetails[0].postid);
                                          setState(() {
                                            _isPressed = true;
                                          });
                                        }
                                      },
                                      icon: (userDetails.likes
                                              .contains(postDetails[0].postid))
                                          ? Icon(
                                              Icons.favorite_rounded,
                                              color: orange,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                              color: orange,
                                            ),
                                      label: (_isPressed)
                                          ? Text(
                                              "Liked",
                                              style: TextStyle(color: orange),
                                            )
                                          : Text(
                                              "Like",
                                              style: TextStyle(color: orange),
                                            )),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Text(
                                    "             " +
                                        postDetails[0].commentsNumber +
                                        " comments",
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.start,
                                  ),
                                  FlatButton.icon(
                                      onPressed: () {
                                        cmntdocid = postDetails[0].postid;
                                        cmntNumbers =
                                            postDetails[0].commentsNumber;
                                        indexcmnt = 0;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  (CommentScreen())),
                                        );
                                      },
                                      icon: Icon(
                                        Icons.comment,
                                        color: orange,
                                      ),
                                      label: Text(
                                        "Comment",
                                        style: TextStyle(color: orange),
                                      )),
                                ],
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
    );
  }
}
