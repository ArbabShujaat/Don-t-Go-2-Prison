import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Constants/constant.dart';
import 'package:design_app/Funtions.dart';
import 'package:design_app/Models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

final Color orange = Color(0XFFd45a29);

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File imagefile;
  File _image;
  bool signupLoading = false;
  double _height;
  double _width;
  bool imagecheck = false;
  bool piccheck = false;
  bool postLoading = false;
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: new IconThemeData(color: orange),
          centerTitle: true,
          title: Text(
            "Add Post",
            style: TextStyle(color: orange),
          ),
          backgroundColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "Don't Go 2 Prison Go ",
                      style: TextStyle(
                          color: orange,
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
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: orange)),
                                      hintText: "Add  Caption",
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
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Add Picture",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: orange),
                                  ),
                                  IconButton(
                                      alignment: Alignment.bottomLeft,
                                      icon: Icon(
                                        Icons.camera_enhance,
                                        color: orange,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        _showdialogbox(context);
                                      })
                                ],
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
                                if (imagecheck &&
                                    _formKey.currentState.validate()) {
                                  print("Hi");
                                  addPost();
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
                              child: Text(
                                "Post",
                                style: new TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                    )
                  ],
                ))));
  }

  Future<void> addPost() async {
    setState(() {
      postLoading = true;
    });

    PostDetails postDetails = PostDetails(
        postUsername: userDetails.username,
        time: DateTime.now().toString(),
        postUserPic: userDetails.userpic,
        postUserid: userDetails.userUid,
        postPic: imageUrl,
        postCaption: "Don't Go 2 Prison Go " + captionController.text,
        likesNumber: '0',
        commentsNumber: '0');

    Firebase.initializeApp();
    await FirebaseFirestore.instance.collection("Posts").add({
      'userName': postDetails.postUsername,
      'userPic': postDetails.postUserPic,
      'userUid': postDetails.postUserid,
      'likesNumber': postDetails.likesNumber,
      'commentsNumber': postDetails.commentsNumber,
      'postPicture': postDetails.postPic,
      'postCaption': postDetails.postCaption,
      'dateTime': postDetails.time,
    });

    await FirebaseFirestore.instance
        .collection("Users")
        .document(userDetails.docid)
        .update({"Posts": (int.parse(userDetails.posts) + 1).toString()});
    posts.clear();
    await fetchtPosts();
    setState(() {
      postLoading = false;
    });
    Navigator.pop(context);
  }

  Future<File> pickImage(BuildContext context, ImageSource source) async {
    File selected = (await ImagePicker.pickImage(
      source: source,
      imageQuality: 20,
    )) as File;
    return selected;
  }
}
