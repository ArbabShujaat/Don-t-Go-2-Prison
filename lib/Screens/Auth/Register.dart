import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/Auth/LoginScreen.dart';
import 'package:design_app/Screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../Funtions.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  File _image;
  bool signupLoading = false;
  double _height;
  double _width;
  bool imagecheck = false;
  bool piccheck = false;

  String imageUrl;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController ageContoller = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  File imagefile;

  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String email = "  ";
  String password = "  ";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: orange),
          backgroundColor: Colors.white,
          title: Text(
            "Create Your Account",
            style: TextStyle(
              color: Color(0XFFd45a29),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: 25.0,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                          backgroundColor: orange,
                          radius: 55,
                          child: CircleAvatar(
                            radius: 50,
                            child: ClipOval(
                              child: SizedBox(
                                  height: 130.0,
                                  width: 130.0,
                                  child: (_image != null)
                                      ? Image.file(
                                          _image,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          color: Colors.white,
                                        )),
                            ),
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                          onTap: () async {
                            _image =
                                await pickImage(context, ImageSource.gallery);
                            setState(() {
                              piccheck = true;
                            });
                            if (_image != null) {
                              print("HII");
                              final FirebaseStorage _storgae = FirebaseStorage(
                                  storageBucket:
                                      'gs://don-t-go-to-prison.appspot.com');
                              print("HII");
                              StorageUploadTask uploadTask;
                              String filePath = '${DateTime.now()}.png';
                              uploadTask = _storgae
                                  .ref()
                                  .child(filePath)
                                  .putFile(_image);
                              uploadTask.onComplete.then((_) async {
                                print(1);
                                String url1 = await uploadTask.lastSnapshot.ref
                                    .getDownloadURL();
                                _image.delete().then((onValue) {
                                  print(2);
                                });
                                setState(() {
                                  imagecheck = true;
                                });
                                print(url1);

                                imageUrl = url1;
                              });
                            }
                          },
                          child: FlatButton.icon(
                              onPressed: () async {
                                _image = await pickImage(
                                    context, ImageSource.gallery);
                                setState(() {
                                  piccheck = true;
                                });
                                if (_image != null) {
                                  final FirebaseStorage _storgae = FirebaseStorage(
                                      storageBucket:
                                          'gs://don-t-go-to-prison.appspot.com');
                                  StorageUploadTask uploadTask;
                                  String filePath = '${DateTime.now()}.png';
                                  uploadTask = _storgae
                                      .ref()
                                      .child(filePath)
                                      .putFile(_image);
                                  uploadTask.onComplete.then((_) async {
                                    print(1);
                                    String url1 = await uploadTask
                                        .lastSnapshot.ref
                                        .getDownloadURL();
                                    _image.delete().then((onValue) {
                                      print(2);
                                    });
                                    setState(() {
                                      imagecheck = true;
                                    });
                                    print(url1);

                                    imageUrl = url1;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.picture_in_picture_alt,
                                color: orange,
                              ),
                              label: Text(
                                "Upload Profle Picture",
                                style: TextStyle(color: orange, fontSize: 17),
                              ))),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.all(20.0),
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
                              textAlign: TextAlign.center,
                              controller: fullnameController,
                              decoration: new InputDecoration(
                                hintText: "Name",
                                hintStyle: TextStyle(
                                  color: orange,
                                ),
                                fillColor: orange,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val.length == 0) {
                                  return "name cannot be empty";
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
                      padding: EdgeInsets.all(20.0),
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
                              textAlign: TextAlign.center,
                              controller: ageContoller,
                              decoration: new InputDecoration(
                                hintText: "Age",
                                hintStyle: TextStyle(
                                  color: orange,
                                ),
                                fillColor: orange,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Age cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),
                            )),
                      )),
                  Padding(
                      padding: EdgeInsets.all(20.0),
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
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Email cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              decoration: new InputDecoration(
                                hintText: "Enter Your Email",
                                hintStyle: TextStyle(
                                  color: orange,
                                ),
                                fillColor: Color(0xFF88B5E9),
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                              )),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(20.0),
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
                              validator: (val) {
                                if (val.length == 0) {
                                  return "Password cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: _obscureText,
                              controller: passwordController,
                              textAlign: TextAlign.center,
                              decoration: new InputDecoration(
                                suffixIcon: GestureDetector(
                                    onTap: _toggle,
                                    child: new Icon(_obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility)),

                                hintText: "Enter Your Password",
                                hintStyle: TextStyle(color: orange),
                                fillColor: orange,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(25.0),
                                  borderSide: new BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              style: new TextStyle(
                                color: Colors.black,
                                fontFamily: "Poppins",
                              ),
                            )),
                      )),
                  Container(
                    child: signupLoading
                        ? CircularProgressIndicator()
                        : MaterialButton(
                            shape: StadiumBorder(),
                            height: 50,
                            minWidth: 250,
                            onPressed: () async {
                              //Condition to see if profile image is uploaded
                              if (imagecheck &&
                                  _formKey.currentState.validate()) {
                                print("Hi");
                                signUp();
                              } else {
                                imagecheck == false
                                    ? showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      18.0),
                                              side: BorderSide(
                                                color: Colors.red[400],
                                              )),
                                          title: Text("Wait..."),
                                          content: Text("Image Not Uploaded"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                "OK",
                                                style: TextStyle(
                                                    color: Colors.red[400]),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            )
                                          ],
                                        ))
                                    : null;
                              }
                            },
                            child: Container(
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Poppins"),
                              ),
                            ),
                            color: orange,
                          ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
                    child: Text("Already have a Account",
                        style: TextStyle(color: orange, fontSize: 18)),
                  )
                ],
              ),
            )));
  }

  Future<File> pickImage(BuildContext context, ImageSource source) async {
    File selected = (await ImagePicker.pickImage(
      source: source,
      imageQuality: 20,
    )) as File;
    return selected;
  }

  Future<void> signUp() async {
    setState(() {
      signupLoading = true;
    });
    print(emailController.text);
    print(passwordController.text);
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;

      print(1);

      if (user != null) {
        print(2);
        print(2);
        var prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'userEmail': user.email,
            'userUid': user.uid,
            'password': passwordController.text,
          },
        );
        prefs.setString('userData', userData);

        List<String> likes = [""];

        Firebase.initializeApp();
        await FirebaseFirestore.instance.collection("Users").add({
          'email': emailController.text,
          'name': fullnameController.text,
          'age': ageContoller.text,
          'useruid': user.uid,
          'userimage': imageUrl,
          'Following': "0",
          'Followers': '0',
          'Posts': "0",
          'Likes': likes,
          'Blocked': false
        });
        print(3);
        try {
          await FirebaseFirestore.instance
              .collection("Users")
              .where("email", isEqualTo: emailController.text)

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
                        docid: value.documents[0].documentID)
                  });
          await fetchtPosts();
          await fetchAllUsers();
        } catch (e) {
          print(e);
        }

        print(4);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => MyHomePage()),
            (Route<dynamic> route) => false);

        setState(() {
          signupLoading = false;
        });
      }
    } catch (signUpError) {
      setState(() {
        signupLoading = false;
      });

      //Error handling
      if (signUpError is PlatformException) {
        if (signUpError.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
          showDialog(
              context: context,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.red[400],
                    )),
                title: Text("Email already in use"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.red[400]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
        }

        if (signUpError.code == 'ERROR_WEAK_PASSWORD') {
          showDialog(
              context: context,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.red[400],
                    )),
                title: Text("Weak Password"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.red[400]),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              ));
        }

        if (signUpError.code == 'ERROR_INVALID_EMAIL') {
          showDialog(
              context: context,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.red[400],
                    )),
                title: Text("Invalid Email"),
                actions: <Widget>[
                  FlatButton(
                    child: Text(
                      "OK",
                      style: TextStyle(color: Colors.red[400]),
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
}
