import 'package:design_app/Admin/AdminHome.dart';
import 'package:design_app/Funtions.dart';
import 'package:design_app/Models/models.dart';
import 'package:flutter/material.dart';

import 'Search/search.dart';
import 'otheruserprofile.dart';
import 'otheruserprofile2.dart';

final Color orange = Color(0XFFd45a29);

class Following extends StatefulWidget {
  @override
  _FollowingState createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  bool _isLoading = false;
  @override
  Future<void> didChangeDependencies() async {
    await ffFetch(searchedUsers, false);
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
            "Following",
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
