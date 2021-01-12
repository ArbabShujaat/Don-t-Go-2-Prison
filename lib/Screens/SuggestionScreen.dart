import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Models/models.dart';
import 'package:flutter/material.dart';

import '../Funtions.dart';
import 'Search/search.dart';
import 'home.dart';
import 'otheruserprofile2.dart';

class SuggestionScreen extends StatefulWidget {
  @override
  _SuggestionScreenState createState() => _SuggestionScreenState();
}

class _SuggestionScreenState extends State<SuggestionScreen> {
  @override
  bool _isLoading = true;
  List<bool> __buttonisLoading = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  bool _following = false;
  List<bool> _followingList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  Future<void> didChangeDependencies() async {
    suggestionusers.clear();
    await FirebaseFirestore.instance
        .collection("Users")
        .getDocuments()
        .then((value) => {
              lengthUser = value.documents.length,
              if (lengthUser > 10)
                for (int i = 0; i < 10; i++)
                  {
                    if (value.documents[i]["useruid"] != userDetails.userUid)
                      suggestionusers.add(FetchedAllUser(
                        userEmail: value.documents[i]["email"],
                        followers: value.documents[i]["Followers"],
                        following: value.documents[i]["Following"],
                        posts: value.documents[i]["Posts"],
                        userUid: value.documents[i]["useruid"],
                        userage: value.documents[i]["age"],
                        username: value.documents[i]["name"],
                        userpic: value.documents[i]["userimage"],
                        blocked: value.documents[i]["Blocked"],
                        website: value.documents[i]["Website"],
                        bio: value.documents[i]["Bio"],
                        docid: value.documents[i].documentID,
                      ))
                  }
              else
                {
                  for (int i = 0; i < lengthUser; i++)
                    {
                      if (value.documents[i]["useruid"] != userDetails.userUid)
                        suggestionusers.add(FetchedAllUser(
                          userEmail: value.documents[i]["email"],
                          followers: value.documents[i]["Followers"],
                          following: value.documents[i]["Following"],
                          posts: value.documents[i]["Posts"],
                          userUid: value.documents[i]["useruid"],
                          userage: value.documents[i]["age"],
                          username: value.documents[i]["name"],
                          userpic: value.documents[i]["userimage"],
                          blocked: value.documents[i]["Blocked"],
                          website: value.documents[i]["Website"],
                          bio: value.documents[i]["Bio"],
                          docid: value.documents[i].documentID,
                        ))
                    }
                }
            });
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
            "Suggestions",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                minWidth: 100,
                height: 50,
                // shape: StadiumBorder(),
                color: Colors.white,
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await fetchtPosts();
                  await fetchAllUsers();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                      (Route<dynamic> route) => false);
                },
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      "Next",
                      style: TextStyle(color: orange, fontSize: 18),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: orange,
                  )
                ]),
              ),
            ),
          ],
          backgroundColor: orange,
        ),
        body: Container(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: suggestionusers.length,
                      itemBuilder: (context, index) => InkWell(
                          onTap: () async {
                            searchedUsers.clear();
                            await setsearched(suggestionusers[index].username);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OtherUserProfile2()),
                            );
                          },
                          child: Column(children: [
                            ListTile(
                              leading: Container(
                                width: 50.0,
                                height: 50.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: new NetworkImage(
                                            suggestionusers[index].userpic))),
                              ),
                              title: Text(
                                suggestionusers[index].username,
                                style: TextStyle(
                                    color: orange,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Container(
                                child: __buttonisLoading[index]
                                    ? Container(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator())
                                    : MaterialButton(
                                        minWidth: 120,
                                        height: 40,
                                        shape: StadiumBorder(),
                                        color: _followingList[index]
                                            ? Colors.white
                                            : orange,
                                        onPressed: () async {
                                          setState(() {
                                            __buttonisLoading[index] = true;
                                          });
                                          await followUserSuggestion(
                                              suggestionusers[index]);
                                          setState(() {
                                            _followingList[index] = true;
                                            __buttonisLoading[index] = false;
                                          });
                                        },
                                        child: _followingList[index]
                                            ? Text(
                                                "Following",
                                                style: TextStyle(
                                                    color: orange,
                                                    fontSize: 16),
                                              )
                                            : Text(
                                                "Follow",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                      ),
                              ),
                            ),
                            Divider(
                              thickness: 2,
                            )
                          ]))),
                ),
        ));
  }
}
