import 'dart:io';
import 'dart:async';

import 'package:design_app/Admin/AdminHome.dart';
import 'package:design_app/Constants/constant.dart';
import 'package:design_app/Screens/Auth/Register.dart';
import 'package:design_app/Screens/Auth/test.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';

class Cropimage extends StatefulWidget {
  @override
  _CropimageState createState() => new _CropimageState();
}

class _CropimageState extends State<Cropimage> {
  final cropKey = GlobalKey<CropState>();
  File _file;
  File _sample;
  File _lastCropped;
  bool loadingCheck = true;

  // @override
  // void dispose() {
  //   super.dispose();
  //   _file?.delete();
  //   _sample?.delete();
  //   _lastCropped?.delete();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Profile Picture"),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: _sample == null ? _buildOpeningImage() : _buildCroppingImage(),
        ),
      ),
    );
  }

  Widget _buildOpeningImage() {
    return Container(
        color: Colors.white, child: Center(child: _buildOpenImage()));
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(
            _sample,
            key: cropKey,

            // aspectRatio: 2,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              loadingCheck
                  ? FlatButton(
                      child: Text(
                        'Crop Image',
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: orange),
                      ),
                      onPressed: () => _cropImage(),
                    )
                  : Center(child: CircularProgressIndicator()),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOpenImage() {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Open Gallery',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: orange, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.image,
                        color: orange,
                      ),
                    )
                  ]),
              onPressed: () => _openImage(ImageSource.gallery),
            ),
            FlatButton(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Open Camera',
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(color: orange, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera_alt,
                        color: orange,
                      ),
                    )
                  ]),
              onPressed: () => _openImage(ImageSource.camera),
            ),
          ]),
    );
  }

  Future<void> _openImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size.longestSide.ceil(),
    );

    _sample?.delete();
    _file?.delete();

    setState(() {
      _sample = sample;
      _file = file;
    });
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState.scale;
    final area = cropKey.currentState.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await ImageCrop.sampleImage(
      file: _file,
      preferredSize: (2000 / scale).round(),
    );

    final file = await ImageCrop.cropImage(
      file: sample,
      area: area,
    );

    // sample.delete();

    _lastCropped?.delete();
    imageSignup = file;

    if (imageSignup != null) {
      setState(() {
        imagecheck = false;
        loadingCheck = false;
      });
      final FirebaseStorage _storgae =
          FirebaseStorage(storageBucket: 'gs://don-t-go-to-prison.appspot.com');
      StorageUploadTask uploadTask;
      String filePath = '${DateTime.now()}.png';
      uploadTask = _storgae.ref().child(filePath).putFile(imageSignup);
      uploadTask.onComplete.then((_) async {
        print(1);
        String url1 = await uploadTask.lastSnapshot.ref.getDownloadURL();
        // imageSignup.delete().then((onValue) {
        //   print(2);
        // });
        setState(() {
          imagecheck = true;
          loadingCheck = true;
        });
        print(url1);

        imageUrl = url1;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Register()),
        );
      });
    }

    debugPrint('$file');
  }
}
