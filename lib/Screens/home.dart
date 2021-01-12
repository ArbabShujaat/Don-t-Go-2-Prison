import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:design_app/Constants/constant.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/AddtoPostScreen.dart';
import 'package:design_app/Screens/Auth/LoginScreen.dart';
import 'package:design_app/Screens/Settings.dart';
import 'package:design_app/Screens/contactUs.dart';
import 'package:design_app/Screens/otheruserprofile2.dart';
import 'package:design_app/Screens/searchscreen.dart';
import 'package:design_app/Screens/userprofile.dart';
import 'package:design_app/main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Funtions.dart';
import 'CommentScreen.dart';
import 'Search/search.dart';
import 'stories.dart';
import 'package:intl/intl.dart';

bool isPressed = false;

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    await fetchtPosts();
    await fetchAllUsers();
    setState(() {});
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final Color orange = Color(0XFFd45a29);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: new Container(
        color: orange,
        height: 50.0,
        alignment: Alignment.center,
        child: new BottomAppBar(
          color: orange,
          child: new Row(
            // alignment: MainAxisAlignment.spaceAround,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new IconButton(
                icon: Icon(
                  Icons.home,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              new IconButton(
                icon: Icon(
                  Icons.add_box,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddPost()),
                ),
              ),
              new IconButton(
                  icon: Icon(
                    Icons.account_box,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    searchedUsers.clear();
                    await setsearched(userDetails.username);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfile()),
                    );
                  }),
              new IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Theme(
          data: Theme.of(context).copyWith(
            canvasColor:
                Colors.white, //This will change the drawer background to blue.
            //other styles
          ),
          child: Drawer(
              child: Column(children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Colors.black, Colors.deepOrange])),
              accountName: Text(
                userDetails.username,
                style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              // accountEmail: Text(
              //   // userDetails.userEmail,
              //   '',
              //   style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w400,
              //       color: Colors.white),
              // ),
              currentAccountPicture: Container(
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: CachedNetworkImage(
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    imageUrl: userDetails.userpic,
                    placeholder: (context, url) =>
                        Center(child: new CircularProgressIndicator()),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ),
              ),
            ),
            new ListTile(
              onTap: () {
                signOut(context);
              },
              trailing: IconButton(
                  color: orange,
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    signOut(context);
                  }),
              title: Text(
                "Logout",
                style: TextStyle(
                    color: orange, fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: orange,
              height: 10,
              thickness: 1,
            ),
            new ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              ),
              trailing: IconButton(
                  color: orange, icon: Icon(Icons.settings), onPressed: () {}),
              title: Text(
                "About",
                style: TextStyle(
                    color: orange, fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: orange,
              height: 10,
              thickness: 1,
            ),
            new ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Contact()),
              ),
              trailing: IconButton(
                  color: orange, icon: Icon(Icons.message), onPressed: () {}),
              title: Text(
                "Contact Us",
                style: TextStyle(
                    color: orange, fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              color: orange,
              height: 10,
              thickness: 1,
            ),
          ]))),
      appBar: AppBar(
        iconTheme: new IconThemeData(color: Colors.white),
        backgroundColor: orange,
        centerTitle: true,
        title: Image.asset(
          "assets/logoo.jpeg",
          height: 80,
          width: 200,
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  showSearch(context: context, delegate: DataSearch());
                },
                child: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ))
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        // enablePullUp: true,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: posts.length,
            itemBuilder: (context, index) => (AnimatedSwitcher(
                  duration: Duration(milliseconds: 450),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) =>
                          SlideTransition(
                    child: child,
                    position: Tween<Offset>(
                            begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                        .animate(animation),
                  ),
                  child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              searchedUsers.clear();
                              await setsearched(posts[index].postUsername);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OtherUserProfile2()));
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
                                            posts[index].postUserPic))),
                              ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    posts[index].postUsername,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  Text(
                                    formatDate(
                                        DateTime.parse(posts[index].time),
                                        [M, ' ', d, ', ', yyyy]),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    posts[index].postCaption,
                                    style:
                                        TextStyle(color: orange, fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: posts[index].postPic,
                            placeholder: (context, url) => Container(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                    child: new CircularProgressIndicator())),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: orange.withOpacity(0.5))),
                            height: 80.0,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: 5.0,
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      posts[index].likesNumber +
                                          " Likes                                       ",
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.start,
                                    ),
                                    FlatButton.icon(
                                        onPressed: () async {
                                          if (!userDetails.likes
                                              .contains(posts[index].postid)) {
                                            await addLike(
                                                posts[index].postid,
                                                int.parse(
                                                    posts[index].likesNumber));
                                            int likes = int.parse(
                                                    posts[index].likesNumber) +
                                                1;
                                            posts[index].likesNumber =
                                                likes.toString();
                                            userDetails.likes
                                                .add(posts[index].postid);
                                            setState(() {
                                              isPressed = true;
                                            });
                                          }
                                        },
                                        icon: (userDetails.likes
                                                .contains(posts[index].postid))
                                            ? Icon(
                                                Icons.favorite_rounded,
                                                color: orange,
                                              )
                                            : Icon(
                                                Icons.favorite_border,
                                                color: orange,
                                              ),
                                        label: (isPressed)
                                            ? Text(
                                                "Liked",
                                                style: TextStyle(color: orange),
                                              )
                                            : Text(
                                                "Like",
                                                style: TextStyle(color: orange),
                                              )),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      "             " +
                                          posts[index].commentsNumber +
                                          " comments",
                                      style: TextStyle(color: Colors.grey),
                                      textAlign: TextAlign.start,
                                    ),
                                    FlatButton.icon(
                                        onPressed: () {
                                          cmntdocid = posts[index].postid;
                                          cmntNumbers =
                                              posts[index].commentsNumber;
                                          indexcmnt = index;
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    (CommentScreen())),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.comment,
                                          color: orange,
                                        ),
                                        label: Text(
                                          "Comment",
                                          style: TextStyle(color: orange),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  // child: HeaderSection(),
                ))),
      ),

      // Flexible(
      //   child: Stories(),
      // )
    );
  }
}
