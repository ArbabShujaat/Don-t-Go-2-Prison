import 'package:design_app/Admin/AdminHome.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatefulWidget {
  Contact({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  void customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command);
    } else {
      print(' could not launch $command');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: orange,
        title: Text('Contact'),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              height: 150,
              child: Image(image: AssetImage('assets/logoo.jpeg')),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 40),
                  RaisedButton.icon(
                    color: orange,
                    padding: EdgeInsets.fromLTRB(84, 5, 83, 5),
                    icon: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      customLaunch(
                          'mailto:dontgotoprisonapp@gmail.com?subject=&body=');
                    },
                    label: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // RaisedButton.icon(
                  //   color: Colors.red[800],
                  //   padding: EdgeInsets.fromLTRB(80, 5, 80, 5),
                  //   icon: Icon(
                  //     Icons.phone,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () {
                  //     customLaunch('tel: +1 (530)7133971');
                  //   },
                  //   label: Text(
                  //     'Phone',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                  // RaisedButton.icon(
                  //   color: Colors.red[800],
                  //   padding: EdgeInsets.fromLTRB(87, 5, 87, 5),
                  //   icon: Icon(
                  //     Icons.message,
                  //     color: Colors.white,
                  //   ),
                  //   onPressed: () {
                  //     customLaunch('sms: +1 (530)7133971');
                  //   },
                  //   label: Text(
                  //     'SMS',
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       color: Colors.white,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
