import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Funtions.dart';
import 'home.dart';

final Color orange = Color(0XFFd45a29);

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Future _uploadImage() async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child("myimage.png");
    StorageUploadTask uploadTask = reference.putFile(imagefile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  }

  File imagefile;
  _openGallery() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imagefile = picture;
    });
  }

  bool _obscureText = true;
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _showdialogbox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Take a Picture"),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    onTap: () {
                      _openGallery();
                      Navigator.of(context).pop();
                    },
                    child: Text("Open Galley"),
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  GestureDetector(
                    child: Text("Open Camera"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  final _auth = FirebaseAuth.instance;
  // TextEditingController emailController = new TextEditingController();

  // TextEditingController passwordController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = "  ";
  String password = "  ";
  File _image;
  bool signupLoading = false;
  double _height;
  double _width;
  bool imagecheck = false;
  bool piccheck = false;

  bool nameEdit = false;
  bool ageEdit = false;
  bool picEdit = false;

  String imageUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: orange),
          backgroundColor: Colors.white,
          title: Text(
            "Edit Your Profile",
            style: TextStyle(
              color: Color(0XFFd45a29),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: signupLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: [
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
                            radius: 70,
                            child: ClipOval(
                              child: SizedBox(
                                  height: 130.0,
                                  width: 130.0,
                                  child: (imagefile != null)
                                      ? Image.file(
                                          imagefile,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    userDetails.userpic)),
                                          ),
                                        )),
                            ),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          GestureDetector(
                              onTap: () async {
                                _image = await pickImage(
                                    context, ImageSource.gallery);
                                setState(() {
                                  piccheck = true;
                                });
                                if (_image != null) {
                                  setState(() {
                                    picEdit = true;
                                  });
                                  final FirebaseStorage _storgae = FirebaseStorage(
                                      storageBucket:
                                          'gs://don-t-go-to-prison.appspot.com/');
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
                              child: FlatButton.icon(
                                  onPressed: () async {
                                    _image = await pickImage(
                                        context, ImageSource.gallery);
                                    setState(() {
                                      piccheck = true;
                                    });
                                    if (_image != null) {
                                      setState(() {
                                        picEdit = true;
                                      });
                                      final FirebaseStorage _storgae =
                                          FirebaseStorage(
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
                                    Icons.edit,
                                    color: orange,
                                  ),
                                  label: Text(
                                    "Edit Profle Picture",
                                    style:
                                        TextStyle(color: orange, fontSize: 17),
                                  ))),
                          // imagefile == null
                          //     ? Text("")
                          //     : MaterialButton(
                          //         shape: StadiumBorder(),
                          //         color: orange,
                          //         onPressed: () {},
                          //         child: Text(
                          //           "Save",
                          //           style: TextStyle(color: Colors.white),
                          //         ),
                          //       ),
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
                                  primaryColor: orange,
                                  primaryColorDark: orange,
                                ),
                                child: TextFormField(
                                  onChanged: (a) {
                                    setState(() {
                                      nameEdit = true;
                                    });
                                  },
                                  controller: nameController,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.edit,
                                      color: orange,
                                    ),
                                    hintText: userDetails.username,
                                    hintStyle: TextStyle(
                                      color: orange,
                                    ),
                                    fillColor: orange,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  keyboardType: TextInputType.name,
                                  style: new TextStyle(
                                    color: orange,
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
                                  primaryColor: orange,
                                  primaryColorDark: orange,
                                ),
                                child: TextFormField(
                                  onChanged: (a) {
                                    setState(() {
                                      ageEdit = true;
                                    });
                                  },
                                  controller: ageController,
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.edit,
                                      color: orange,
                                    ),
                                    hintText: userDetails.userage,
                                    hintStyle: TextStyle(
                                      color: orange,
                                    ),
                                    fillColor: orange,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
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
                                  keyboardType: TextInputType.number,
                                  style: new TextStyle(
                                    color: orange,
                                    fontFamily: "Poppins",
                                  ),
                                )),
                          )),
                      MaterialButton(
                        shape: StadiumBorder(),
                        height: 50,
                        minWidth: 250,
                        onPressed: () async {
                          if (picEdit) if (imagecheck) {
                            print("Hi");
                            update();
                          } else {
                            imagecheck == false
                                ? showDialog(
                                    context: context,
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(18.0),
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
                          else
                            update();
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: "Poppins"),
                        ),
                        color: orange,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ]),
                  )),
        ));
  }

  Future<File> pickImage(BuildContext context, ImageSource source) async {
    File selected = (await ImagePicker.pickImage(
      source: source,
      imageQuality: 20,
    )) as File;
    return selected;
  }

  Future<void> update() async {
    setState(() {
      signupLoading = true;
    });

    print(1);

    List<String> likes = [""];

    Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("Users")
        .document(userDetails.docid)
        .update({
      'name': nameEdit ? nameController.text : userDetails.username,
      'age': ageEdit ? ageController.text : userDetails.userage,
      'userimage': picEdit ? imageUrl : userDetails.userpic,
    });
    print(2);

    await FirebaseFirestore.instance
        .collection("Posts")
        .where('userUid', isEqualTo: userDetails.userUid)
        .getDocuments()
        .then((value) {
      int length = value.documents.length;
      for (int i = 0; i < length; i++) {
        FirebaseFirestore.instance
            .collection("Posts")
            .doc(value.documents[i].documentID)
            .update({
          "userName": nameEdit ? nameController.text : userDetails.username,
          "userPic": picEdit ? imageUrl : userDetails.userpic,
        });
      }
    });
    print(3);

    await FirebaseFirestore.instance
        .collection("Users")
        .getDocuments()
        .then((value) async {
      for (int i = 0; i < value.documents.length; i++) {
        print("entered");
        FirebaseFirestore.instance
            .collection("Users")
            .document(value.documents[i].documentID)
            .collection("FollowersList")
            .where("userUid", isEqualTo: userDetails.userUid)
            .getDocuments()
            .then((value2) async {
          print("entered2");
          FirebaseFirestore.instance
              .collection("Users")
              .document(value.documents[i].documentID)
              .collection("FollowersList")
              .document(value2.documents[0].documentID)
              .update({
            "userName": nameEdit ? nameController.text : userDetails.username,
            "userImage": picEdit ? imageUrl : userDetails.userpic,
          });
          print("entered3");
        });

        FirebaseFirestore.instance
            .collection("Users")
            .document(value.documents[i].documentID)
            .collection("FollowingList")
            .where("userUid", isEqualTo: userDetails.userUid)
            .getDocuments()
            .then((value2) async {
          print("entered2");
          FirebaseFirestore.instance
              .collection("Users")
              .document(value.documents[i].documentID)
              .collection("FollowingList")
              .document(value2.documents[0].documentID)
              .update({
            "userName": nameEdit ? nameController.text : userDetails.username,
            "userImage": picEdit ? imageUrl : userDetails.userpic,
          });
          print("entered3");
        });
      }
    });

    await FirebaseFirestore.instance
        .collection("Posts")
        .getDocuments()
        .then((value) async {
      for (int i = 0; i < value.documents.length; i++) {
        print("entered");
        FirebaseFirestore.instance
            .collection("Posts")
            .document(value.documents[i].documentID)
            .collection("Comments")
            .where("userUid", isEqualTo: userDetails.userUid)
            .getDocuments()
            .then((value2) async {
          print("entered2");
          FirebaseFirestore.instance
              .collection("Posts")
              .document(value.documents[i].documentID)
              .collection("Comments")
              .document(value2.documents[0].documentID)
              .update({
            "userName": nameEdit ? nameController.text : userDetails.username,
            "userImage": picEdit ? imageUrl : userDetails.userpic,
          });
          print("entered3");
        });
      }
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .where("email", isEqualTo: userDetails.userEmail)

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
                docid: value.documents[0].documentID,
              )
            });
    print(4);

    await fetchtPosts();
    await fetchAllUsers();

    // add({
    // 'email': emailController.text,
    // 'name': fullnameController.text,
    // 'age': ageContoller.text,
    // 'useruid': user.uid,
    // 'userimage': imageUrl,
    // 'Following': "0",
    // 'Followers': '0',
    // 'Posts': "0",
    // 'Likes': likes
    // });
    print(3);

    print(4);

    setState(() {
      signupLoading = false;
    });
  }
}
