import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Constants/constant.dart';
import 'package:design_app/Funtions.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/PictureDetailScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home.dart';

class EditPost extends StatefulWidget {
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  File imagefile;
  File _image;
  bool _edit = false;
  bool signupLoading = false;
  double _height;
  double _width;
  bool imagecheck = false;
  bool piccheck = false;
  bool postLoading = false;
  bool _loading = true;
  bool _pictureEdit = false;
  TextEditingController captionController = TextEditingController();
  var _formKey = GlobalKey<FormState>();

  String imageUrl;
  _openGallery() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imagefile = picture;
    });
  }

  _openCamera() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imagefile = picture;
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
                    onTap: () async {
                      _image = await pickImage(context, ImageSource.gallery);
                      setState(() {
                        piccheck = true;
                      });
                      if (_image != null) {
                        setState(() {
                          _pictureEdit = true;
                        });
                        final FirebaseStorage _storgae = FirebaseStorage(
                            storageBucket:
                                'gs://don-t-go-to-prison.appspot.com/');
                        StorageUploadTask uploadTask;
                        String filePath = '${DateTime.now()}.png';
                        uploadTask =
                            _storgae.ref().child(filePath).putFile(_image);
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
                      Navigator.pop(context);
                    },
                    child: Text("Open Galley"),
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  GestureDetector(
                    onTap: () async {
                      _image = await pickImage(context, ImageSource.camera);
                      setState(() {
                        piccheck = true;
                      });
                      if (_image != null) {
                        final FirebaseStorage _storgae = FirebaseStorage(
                            storageBucket:
                                'gs://don-t-go-to-prison.appspot.com');
                        StorageUploadTask uploadTask;
                        String filePath = '${DateTime.now()}.png';
                        uploadTask =
                            _storgae.ref().child(filePath).putFile(_image);
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
                      Navigator.pop(context);
                    },
                    child: Text("Open Camera"),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    captionController.dispose();
    super.dispose();
  }

  @override
  Future<void> didChangeDependencies() async {
    var prefs = await SharedPreferences.getInstance();
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
                docid: value.documents[0].documentID,
                website: value.documents[0]["Website"],
                bio: value.documents[0]["Bio"],
              )
            });

    captionController.text = postDetails[0].postCaption;
    print(captionController.text);

    setState(() {
      _loading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: orange),
          centerTitle: true,
          title: Text(
            "Edit Post",
            style: TextStyle(color: orange),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Caption",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        new Theme(
                            data: new ThemeData(
                              primaryColor: Colors.red,
                              primaryColorDark: orange,
                            ),
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(color: orange)),
                                      child: TextFormField(
                                        onChanged: (a) {
                                          setState(() {
                                            _edit = true;
                                          });
                                        },
                                        validator: (val) {
                                          if (val.length == 0) {
                                            return "Caption Cannot be empty";
                                          } else {
                                            return null;
                                          }
                                        },
                                        textAlign: TextAlign.center,
                                        controller: captionController,
                                        decoration: new InputDecoration(
                                          suffixIcon: Icon(Icons.edit),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: orange)),
                                          hintText: postDetails[0].postCaption,
                                          hintStyle: TextStyle(
                                              color: orange,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 15,
                                        style: new TextStyle(
                                          color: orange,
                                          fontFamily: "Poppins",
                                        ),
                                      ))),
                            )),
                        Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: orange, width: 2),
                                borderRadius: BorderRadius.circular(20.0)),
                            width: 300,
                            height: 300,
                            margin: EdgeInsets.all(20.0),
                            padding: EdgeInsets.all(20.0),
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.cover,
                                  )
                                : InkWell(
                                    onTap: () {
                                      _showdialogbox(context);
                                    },
                                    child: Image.network(
                                      postDetails[0].postPic,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        Container(
                          child: postLoading
                              ? Center(child: CircularProgressIndicator())
                              : MaterialButton(
                                  minWidth: 200,
                                  height: 50,
                                  shape: StadiumBorder(),
                                  color: orange,
                                  onPressed: () {
                                    if (_pictureEdit == false) {
                                      imageUrl = postDetails[0].postPic;
                                      addpost();
                                    } else if (imagecheck) {
                                      print("Hi");
                                      addpost();
                                    } else {
                                      imagecheck == false
                                          ? showDialog(
                                              context: context,
                                              child: AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(18.0),
                                                    side: BorderSide(
                                                      color: Colors.red[400],
                                                    )),
                                                title: Text("Wait..."),
                                                content:
                                                    Text("Image Not Uploaded"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    child: Text(
                                                      "OK",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.red[400]),
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
                                  child: Text(
                                    "Update Post",
                                    style: new TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                        )
                      ],
                    ))));
  }

  Future<void> addpost() async {
    setState(() {
      postLoading = true;
    });

    PostDetails postDetailsUpload = PostDetails(
        postUsername: userDetails.username,
        time: DateTime.now().toString(),
        postUserPic: userDetails.userpic,
        postUserid: userDetails.userUid,
        postPic: imageUrl,
        // postCaption: _edit
        //     ? "Don't Go 2 Prison Go " + captionController.text
        //     : postDetails[0].postCaption,
        postCaption: captionController.text,
        likesNumber: '0',
        commentsNumber: '0');

    Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection("Posts")
        .document(postDetails[0].postid)
        .update({
      'postPicture': postDetailsUpload.postPic,
      'postCaption': postDetailsUpload.postCaption,
      'dateTime': postDetailsUpload.time,
    });

    posts.clear();
    await fetchtPosts();
    setState(() {
      postLoading = false;
    });
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (Route<dynamic> route) => false);
  }

  Future<File> pickImage(BuildContext context, ImageSource source) async {
    File selected = (await ImagePicker.pickImage(
      source: source,
      imageQuality: 20,
    )) as File;
    return selected;
  }
}
