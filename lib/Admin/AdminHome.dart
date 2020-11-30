import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Funtions.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/Search/search.dart';
import 'package:design_app/Screens/userprofile.dart';
import 'package:flutter/material.dart';

bool admin = false;
final Color orange = Color(0XFFd45a29);

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool _isLoading = true;
  @override
  Future<void> didChangeDependencies() async {
    await fetchAllUsers();
    setState(() {
      _isLoading = false;
      admin = true;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  signOut(context);
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Icon(Icons.exit_to_app),
                  ],
                ),
              ),
            )
          ],
          title: Text(
            "Admin Pannel",
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
                  itemCount: allusers.length,
                  itemBuilder: (context, index) => ListTile(
                        onTap: () async {
                          searchedUsers.clear();
                          await setsearched(allusers[index].username);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserProfile()),
                          );
                        },
                        trailing: !allusers[index].blocked
                            ? FlatButton(
                                onPressed: () async {
                                  print(allusers[index].docid);
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .document(allusers[index].docid)
                                      .update({"Blocked": true});
                                  setState(() {
                                    allusers[index].blocked = true;
                                  });
                                },
                                child: Text(
                                  "Block",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                ))
                            : FlatButton(
                                onPressed: () async {
                                  print(allusers[index].docid);
                                  await FirebaseFirestore.instance
                                      .collection("Users")
                                      .document(allusers[index].docid)
                                      .update({"Blocked": false});
                                  setState(() {
                                    allusers[index].blocked = false;
                                  });
                                },
                                child: Text(
                                  "Unblock",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                )),
                        leading: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      allusers[index].userpic))),
                        ),
                        title: Text(
                          allusers[index].username,
                          style: TextStyle(
                              color: orange,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
        ));
  }
}
