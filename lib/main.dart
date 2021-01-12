import 'dart:async';
import 'dart:convert';

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Admin/AdminHome.dart';

import 'package:design_app/Funtions.dart';
import 'package:design_app/Screens/CropImage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/models.dart';
import 'Screens/Auth/LoginScreen.dart';
import 'Screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    theme: ThemeData(
        primaryColor: Color(0XFFd45a29), accentColor: Color(0XFFd45a29)),
    debugShowCheckedModeBanner: false,
    home: Splashscreen(),
  ));
}

final Color orange = Color(0XFFd45a29);

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });

    Timer(Duration(seconds: 3), () async {
      var prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey("userData")) {
        if (prefs.containsKey("adminData")) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHome()),
          );
        } else
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
      } else {
        final extractedUserData =
            json.decode(prefs.getString('userData')) as Map<String, Object>;

        await FirebaseFirestore.instance
            .collection("Users")
            .where("email", isEqualTo: extractedUserData['userEmail'])
            // ignore: deprecated_member_use
            .getDocuments()
            .then((value) => {
                  userDetails = UserDetails(
                    userEmail: value.documents[0]["email"],
                    followers: value.documents[0]["Followers"],
                    following: value.documents[0]["Following"],
                    posts: value.documents[0]["Posts"],
                    userUid: value.documents[0]["useruid"],
                    userage: value.documents[0]["age"],
                    username: value.documents[0]["name"],
                    userpic: value.documents[0]["userimage"],
                    likes: value.documents[0]["Likes"],
                    blocked: value.documents[0]["Blocked"],
                    website: value.documents[0]["Website"],
                    bio: value.documents[0]["Bio"],
                    docid: value.documents[0].documentID,
                  )
                });

        await fetchtPosts();
        await fetchAllUsers();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Image.asset(
                "assets/logoo.jpeg",
                height: 200,
              ),
            )),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "The Purpose of the Don’t Go 2 Prison App is to give youth alternatives to going to prison.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: orange, fontSize: 15, fontWeight: FontWeight.bold),
                )),
            SizedBox(
              height: 60,
            ),
            Text(
              "Founded by Attorney Mohammed S. Luwemba",
              style: TextStyle(
                  color: orange, fontSize: 17, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ));
  }
}
