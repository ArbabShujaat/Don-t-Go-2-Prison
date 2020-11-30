import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Constants/constant.dart';
import 'Screens/Auth/LoginScreen.dart';

List followingList = [];
List<String> likes = [];
///////////Fetch Posts//////////////////////////
Future<List<FetchedPostDetails>> fetchtPosts() async {
  followingList = [];
  int length;
  try {
    print(userDetails.docid);
    await FirebaseFirestore.instance
        .collection("Users")
        .document(userDetails.docid)
        .collection("FollowingList")
        .getDocuments()
        .then((value) => {
              length = value.documents.length,
              print(length),
              for (int i = 0; i < length; i++)
                {
                  followingList.add(
                    value.documents[i]["userUid"],
                  ),
                }
            });
  } catch (e) {
    print(e);
  }
  posts.clear();
  await FirebaseFirestore.instance
      .collection("Posts")
      .orderBy('dateTime', descending: true)
      .getDocuments()
      .then((value) {
    int length = value.documents.length;
    for (int i = 0; i < length; i++) {
      if (followingList.contains(value.documents[i]["userUid"]) ||
          userDetails.userUid == value.documents[i]["userUid"])
        posts.add(FetchedPostDetails(
          postUsername: value.documents[i]["userName"],
          time: value.documents[i]["dateTime"],
          postUserPic: value.documents[i]["userPic"],
          postUserid: value.documents[i]["userUid"],
          postPic: value.documents[i]["postPicture"],
          postCaption: value.documents[i]["postCaption"],
          likesNumber: value.documents[i]["likesNumber"],
          commentsNumber: value.documents[i]["commentsNumber"],
          postid: value.documents[i].documentID,
        ));
    }
  });

  return posts;
}

///////////Fetct User Posts//////////////
Future<List<FetchedPostDetails>> fetchtUerPosts(String userId) async {
  List<FetchedPostDetails> userPostList = [];
  await FirebaseFirestore.instance
      .collection("Posts")
      .where('userUid', isEqualTo: userId)
      .getDocuments()
      .then((value) {
    int length = value.documents.length;
    for (int i = 0; i < length; i++) {
      userPostList.add(FetchedPostDetails(
        postUsername: value.documents[i]["userName"],
        time: value.documents[i]["dateTime"],
        postUserPic: value.documents[i]["userPic"],
        postUserid: value.documents[i]["userUid"],
        postPic: value.documents[i]["postPicture"],
        postCaption: value.documents[i]["postCaption"],
        likesNumber: value.documents[i]["likesNumber"],
        commentsNumber: value.documents[i]["commentsNumber"],
        postid: value.documents[i].documentID,
      ));
    }
  });

  return userPostList;
}

///////Add Like//////////////////
Future<void> addLike(String docid, int likes) async {
  await FirebaseFirestore.instance
      .collection("Posts")
      .document(docid)
      .collection("Likes")
      .add({
    "userName": userDetails.username,
    "userUid": userDetails.userUid,
    "userImage": userDetails.userpic,
  });

  await FirebaseFirestore.instance
      .collection("Posts")
      .document(docid)
      .update({"likesNumber": (likes + 1).toString()});

  userDetails.likes.add(docid);

  await FirebaseFirestore.instance
      .collection("Users")
      .document(userDetails.docid)
      .update({"Likes": userDetails.likes});
}

///////Add Comment//////////////////

Future<void> addcomment(
    String docid, String comment, int numberOfComments) async {
  await FirebaseFirestore.instance
      .collection("Posts")
      .document(docid)
      .collection("Comments")
      .add({
    "userName": userDetails.username,
    "userUid": userDetails.userUid,
    "userImage": userDetails.userpic,
    "userComment": comment
  });

  await FirebaseFirestore.instance
      .collection("Posts")
      .document(docid)
      .update({"commentsNumber": (numberOfComments + 1).toString()});
}

///fetch all users/////
int lengthUser;
Future<void> fetchAllUsers() async {
  allusers.clear();
  await FirebaseFirestore.instance
      .collection("Users")
      .getDocuments()
      .then((value) => {
            lengthUser = value.documents.length,
            for (int i = 0; i < lengthUser; i++)
              {
                allusers.add(FetchedAllUser(
                  userEmail: value.documents[i]["email"],
                  followers: value.documents[i]["Followers"],
                  following: value.documents[i]["Following"],
                  posts: value.documents[i]["Posts"],
                  userUid: value.documents[i]["useruid"],
                  userage: value.documents[i]["age"],
                  username: value.documents[i]["name"],
                  userpic: value.documents[i]["userimage"],
                  blocked: value.documents[i]["Blocked"],
                  docid: value.documents[i].documentID,
                ))
              }
          });
}

////////Follow  User/////

Future<void> followUser(List<FetchedAllUser> followedUser) async {
  print(followedUser[0].userpic);

  try {
    await FirebaseFirestore.instance
        .collection("Users")
        .document(userDetails.docid)
        .collection("FollowingList")
        .add({
      "userName": followedUser[0].username,
      "userUid": followedUser[0].userUid,
      "userImage": followedUser[0].userpic,
    });
  } catch (e) {
    print("error");
    print(e);
  }
  try {
    await FirebaseFirestore.instance
        .collection("Users")
        .document(userDetails.docid)
        .update(
            {"Following": (int.parse(userDetails.following) + 1).toString()});
    userDetails.following = (int.parse(userDetails.following) + 1).toString();
    print("follow user");
  } catch (e) {
    print("error2");
    print(e);
  }
  try {
    await FirebaseFirestore.instance
        .collection("Users")
        .document(followedUser[0].docid)
        .collection("FollowersList")
        .add({
      "userName": userDetails.username,
      "userUid": userDetails.userUid,
      "userImage": userDetails.userpic,
    });
  } catch (e) {
    print("error3");
    print(e);
  }
  print("follow user");
  try {
    await FirebaseFirestore.instance
        .collection("Users")
        .document(followedUser[0].docid)
        .update({
      "Followers": (int.parse(followedUser[0].followers) + 1).toString()
    });
  } catch (e) {
    print("error3");
    print(e);
  }
  followedUser[0].followers =
      (int.parse(followedUser[0].followers) + 1).toString();

  print("follow user");
  await fetchtPosts();
}

////////UnFollow  User/////

Future<void> unFollowUser(List<FetchedAllUser> followedUser) async {
  String id1;

  String id2;

  await FirebaseFirestore.instance
      .collection("Users")
      .document(userDetails.docid)
      .collection("FollowingList")
      .where("userUid", isEqualTo: followedUser[0].userUid)
      .getDocuments()
      .then((value) {
    id1 = value.documents[0].documentID;
  });
  await FirebaseFirestore.instance
      .collection("Users")
      .document(userDetails.docid)
      .collection("FollowingList")
      .document(id1)
      .delete();

  //     .add({
  //   "userName": followedUser[0].username,
  //   "userUid": followedUser[0].userUid,
  //   "userImage": followedUser[0].userpic,
  // });

  await FirebaseFirestore.instance
      .collection("Users")
      .document(userDetails.docid)
      .update({"Following": (int.parse(userDetails.following) - 1).toString()});
  userDetails.following = (int.parse(userDetails.following) - 1).toString();

  await FirebaseFirestore.instance
      .collection("Users")
      .document(followedUser[0].docid)
      .collection("FollowersList")
      .where("userUid", isEqualTo: userDetails.userUid)
      .getDocuments()
      .then((value) {
    id2 = value.documents[0].documentID;
  });

  await FirebaseFirestore.instance
      .collection("Users")
      .document(followedUser[0].docid)
      .collection("FollowersList")
      .document(id2)
      .delete();

  await FirebaseFirestore.instance
      .collection("Users")
      .document(followedUser[0].docid)
      .update(
          {"Followers": (int.parse(followedUser[0].followers) - 1).toString()});
  followedUser[0].followers =
      (int.parse(followedUser[0].followers) - 1).toString();

  await fetchtPosts();
}

////////following followers fetch//////
Future<void> ffFetch(List<FetchedAllUser> followedUser, bool followers) async {
  int length;
  print(followedUser[0].docid);
  if (followers && int.parse(followedUser[0].followers) != 0)
    await FirebaseFirestore.instance
        .collection("Users")
        .document(followedUser[0].docid)
        .collection("FollowersList")
        .getDocuments()
        .then((value) => {
              length = value.documents.length,
              for (int i = 0; i < length; i++)
                {
                  followfollowing.add(FollowingFollowers(
                      userUid: value.documents[i]["userUid"],
                      username: value.documents[i]["userName"],
                      userpic: value.documents[i]["userImage"])),
                }
            });

  if (!followers && int.parse(followedUser[0].following) != 0)
    await FirebaseFirestore.instance
        .collection("Users")
        .document(followedUser[0].docid)
        .collection("FollowingList")
        .getDocuments()
        .then((value) => {
              length = value.documents.length,
              for (int i = 0; i < length; i++)
                {
                  followfollowing.add(FollowingFollowers(
                      userUid: value.documents[i]["userUid"],
                      username: value.documents[i]["userName"],
                      userpic: value.documents[i]["userImage"])),
                }
            });
}

//////signout///
Future<void> signOut(BuildContext context) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false);
  } catch (e) {
    print(e); //
  }
}
