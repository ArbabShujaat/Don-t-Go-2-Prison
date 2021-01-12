import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Admin/AdminHome.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../Funtions.dart';
import '../../main.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  double _height;
  double _width;
  double _pixelRatio;
  String adminEmail = '';
  String adminPassword = '';
  bool loginLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> _key = GlobalKey();
  @override
  void didChangeDependencies() {
    Firebase.initializeApp();
    FirebaseFirestore.instance
        .collection('AdminCredentials')
        .getDocuments()
        .then((value) => {
              adminEmail = value.documents[0]['Email'],
              adminPassword = value.documents[0]['Password'],
            });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Form(
            key: _key,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 80.0,
                  ),
                  Image.asset(
                    "assets/logoo.jpeg",
                    height: 200,
                    width: 200,
                  ),
                  Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: new Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black,
                              primaryColorDark: Colors.black,
                            ),
                            child: TextFormField(
                              controller: emailController,
                              textAlign: TextAlign.center,
                              decoration: new InputDecoration(
                                hintText: "Enter Your Email",
                                hintStyle: TextStyle(
                                  color: Color(0XFFd45a29),
                                ),
                                fillColor: Color(0XFFd45a29),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Email cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),
                            )),
                      )),
                  Padding(
                      padding: EdgeInsets.all(30.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: new Theme(
                            data: new ThemeData(
                              primaryColor: Colors.black,
                              primaryColorDark: Colors.black,
                            ),
                            child: TextFormField(
                              obscureText: _obscureText,
                              controller: passwordController,
                              textAlign: TextAlign.center,
                              decoration: new InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: _toggle,
                                    child: new Icon(_obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility)),
                                hintText: "    Enter Your Password",
                                hintStyle: TextStyle(color: Color(0XFFd45a29)),
                                fillColor: Color(0XFFd45a29),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                              ),
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Password cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),
                            )),
                      )),
                  button(),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Register()));
                    },
                    child: Text("Create Your Account Here",
                        style:
                            TextStyle(color: Color(0XFFd45a29), fontSize: 18)),
                  )
                ],
              ),
            )));
  }

  Future<void> addCheckSignup() async {
    await Firebase.initializeApp();
    await Firestore.instance
        .collection("Users")
        .where("Email", isEqualTo: emailController.text)
        .getDocuments()
        .then((value) async => {
              if (value.documents.length > 0)
                {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(
                              color: Colors.red,
                            )),
                        title: Text("Already Loggedin on other device"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ))
                }
              else
                {
                  await Firestore.instance.collection("Users").add({
                    "Email": emailController.text,
                  })
                }
            });
  }

  Future<void> checkLogin() async {
    await Firebase.initializeApp();
    Firestore.instance
        .collection("Users")
        .where("Email", isEqualTo: emailController.text)
        .where("Logged In", isEqualTo: false)
        .getDocuments()
        .then((value) => {
              if (value.documents.length > 0)
                Navigator.pushReplacementNamed(context, "routeName")
            });

    Firestore.instance
        .collection("Users")
        .where("Email", isEqualTo: emailController.text)
        .where("Logged In", isEqualTo: true)
        .getDocuments()
        .then((value) => {
              if (value.documents.length > 0)
                showDialog(
                    context: context,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(
                            color: Colors.red,
                          )),
                      title: Text("Already Loggedin on other device"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text(
                            "OK",
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ))
            });
  }

  Widget button() {
    return loginLoading
        ? CircularProgressIndicator()
        : MaterialButton(
            shape: StadiumBorder(),
            height: 50,
            minWidth: 250,
            onPressed: () async {
              if (_key.currentState.validate()) {
                setState(() {
                  loginLoading = true;
                });
                if (emailController.text == adminEmail &&
                    passwordController.text == adminPassword) {
                  var prefs = await SharedPreferences.getInstance();
                  final adminData = json.encode(
                    {
                      'userEmail': adminEmail,
                      'password': adminPassword,
                    },
                  );
                  prefs.setString('adminData', adminData);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => AdminHome()));
                } else
                  try {
                    final User user = (await _auth.signInWithEmailAndPassword(
                      email: emailController.text,
                      password: passwordController.text,
                    ))
                        .user;

                    if (user != null) {
                      var prefs = await SharedPreferences.getInstance();
                      final userData = json.encode(
                        {
                          'userEmail': user.email,
                          'userUid': user.uid,
                          'password': passwordController.text,
                        },
                      );
                      prefs.setString('userData', userData);

                      await FirebaseFirestore.instance
                          .collection("Users")
                          .where("email", isEqualTo: user.email)

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
                                    docid: value.documents[0].documentID)
                              });

                      print("hi");
                      await fetchtPosts();
                      await fetchAllUsers();
                      if (userDetails.blocked) {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Colors.red,
                                  )),
                              title: Text(
                                "Your account was blocked",
                                style: TextStyle(color: Colors.red),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                      } else
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                    }
                    setState(() {
                      loginLoading = false;
                    });
                  } catch (signUpError) {
                    setState(() {
                      loginLoading = false;
                    });

                    if (true) {
                      if (signUpError.code == 'ERROR_INVALID_EMAIL') {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Colors.red,
                                  )),
                              title: Text("Incorrect Email"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                      } else if (signUpError.code == 'ERROR_WRONG_PASSWORD') {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Colors.red,
                                  )),
                              title: Text("Wrong Password"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                      } else if (signUpError.code == 'ERROR_USER_NOT_FOUND') {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Colors.red,
                                  )),
                              title: Text("No user exists"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                      } else {
                        showDialog(
                            context: context,
                            child: AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(
                                    color: Colors.red,
                                  )),
                              title: Text(signUpError.message),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            ));
                      }
                    }
                  }
              }
            },
            child: Text(
              "Login",
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: "Poppins"),
            ),
            color: Color(0XFFd45a29),
          );
  }

  Widget _textInput({controller, hint, icon}) {
    return Container(
      // height: 60,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.red)),
      ),
      padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
      child: TextFormField(
        controller: controller,
        validator: (String val) {
          if (val.isEmpty) {
            return hint + ' must not be empty';
          }
          return null;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }
}
