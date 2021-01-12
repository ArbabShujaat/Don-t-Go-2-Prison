import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Funtions.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/Following.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Followers.dart';
import 'PictureDetailScreen.dart';

final Color orange = Color(0XFFd45a29);

class UserProfile extends StatefulWidget {
  UserProfile({Key key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

List<FetchedPostDetails> userposts = [];
bool _isLoading = true;
bool following = false;

List images = [
  "assets/4.jpg",
  "assets/f.jpg",
  "assets/s.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
  "assets/t.jpg",
];

class _UserProfileState extends State<UserProfile> {
  @override
  Future<void> didChangeDependencies() async {
    userposts.clear();
    userposts = List.from(await fetchtUerPosts(userDetails.userUid));

    setState(() {
      _isLoading = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: new IconThemeData(color: orange),
        title: Text(
          "About",
          style: TextStyle(color: orange),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: EdgeInsets.all(5.0),
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    "*The Purpose of the Don’t Go 2 Prison App is to give youth alternatives to going to prison.",
                    style: TextStyle(color: orange, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 450),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) =>
                            SlideTransition(
                      child: child,
                      position: Tween<Offset>(
                              begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                          .animate(animation),
                    ),
                    child: HeaderSection(),
                  ),
                  SizedBox(height: 40),
                  Container(
                    color: Colors.white,
                    child: Wrap(
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: SizedBox(
                              height: 400,
                              child: GridView.builder(
                                itemCount: userposts.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    postDetails.clear();
                                    postDetails.add(userposts[index]);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PicDetailScreen()),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: userposts[index].postPic,
                                        placeholder: (context, url) => Container(
                                            child: Center(
                                                child:
                                                    new CircularProgressIndicator())),
                                        errorWidget: (context, url, error) =>
                                            new Icon(Icons.error),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(8.0),
                                    margin: EdgeInsets.all(5.0),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class HeaderSection extends StatefulWidget {
  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  bool ispressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: orange, width: 3.0),
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0)),
      height: 380,
      width: 350,
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(
                  image: NetworkImage(userDetails.userpic), fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 20),
          Container(
            alignment: Alignment.center,
            child: Text(
              userDetails.username,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 24, color: Colors.red),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Bio: ",
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(
                  width: 250,
                  height: 50.0,
                  child: AutoSizeText(
                    userDetails.bio,
                    style: TextStyle(color: Colors.grey),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      userDetails.posts,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: orange),
                    ),
                    Text(
                      'Post',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.redAccent),
                    )
                  ],
                ),
                InkWell(
                    onTap: () {
                      followfollowing.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Followers()),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          userDetails.followers,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: orange),
                        ),
                        Text(
                          'Followers',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.redAccent),
                        )
                      ],
                    )),
                InkWell(
                    onTap: () {
                      followfollowing.clear();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Following()),
                      );
                    },
                    child: Column(
                      children: <Widget>[
                        Text(
                          userDetails.following,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: orange),
                        ),
                        Text(
                          'Following',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.redAccent),
                        )
                      ],
                    ))
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  print(userDetails.website);
                  launch("https://" + userDetails.website);
                },
                child: Row(
                  children: [
                    Text("Website: "),
                    Text(
                      userDetails.website,
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
