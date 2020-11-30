import 'dart:ui';

import 'package:design_app/Admin/AdminHome.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/Search/search.dart';
import 'package:design_app/Screens/otheruserprofile2.dart';
import 'package:flutter/material.dart';

import '../Funtions.dart';
import 'otheruserprofile.dart';

final Color orange = Color(0XFFd45a29);

class Followers extends StatefulWidget {
  @override
  _FollowersState createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  bool _isLoading = true;
  @override
  Future<void> didChangeDependencies() async {
    await ffFetch(searchedUsers, true);
    setState(() {
      _isLoading = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Followers",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: orange,
        ),
        body: Container(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: followfollowing.length,
                  itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        if (!admin) {
                          searchedUsers.clear();
                          await setsearched(followfollowing[index].username);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OtherUserProfile2()),
                          );
                        }
                      },
                      child: ListTile(
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      followfollowing[index].userpic))),
                        ),
                        title: Text(
                          followfollowing[index].username,
                          style: TextStyle(
                              color: orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ))),
        ));
  }
}
