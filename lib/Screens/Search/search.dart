import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:design_app/Models/models.dart';
import 'package:design_app/Screens/Search/searchScreen.dart';
import 'package:design_app/Screens/otheruserprofile.dart';

import 'package:flutter/material.dart';

import '../../main.dart';

class DataSearch extends SearchDelegate<String> {
  DataSearch();
  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for appbar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // leading icon on the left of appbar
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: OtherUserProfilePage(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<FetchedAllUser> aa = [];
    if (query != "") {
      allusers.forEach((i) {
        // ignore: unnecessary_statements

        if (i.username.startsWith(query.toUpperCase()) ||
            i.username.startsWith(query)) aa.add(i);
      });
    }

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onLongPress: () {
          query = aa[index].username.toString();
          try {
            double newquery = double.parse(query);
            print(newquery);
            setsearched(query).then((_) {
              showResults(context);
            });
          } catch (e) {
            print("EROR");
            setsearched(query).then((_) {
              showResults(context);
            });
          }
        },
        onTap: () {
          query = aa[index].username.toString();
          try {
            double newquery = double.parse(query);
            print(newquery);
            setsearched(query).then((_) {
              showResults(context);
            });
          } catch (e) {
            setsearched(query).then((_) {
              showResults(context);
            });
          }
        },
        // leading: Icon(Icons.search),
        title: GestureDetector(
          onTap: () {
            query = aa[index].username.toString();

            try {
              setsearched(query).then((_) {
                showResults(context);
              });
            } catch (e) {
              print("EROR");
              setsearched(query).then((_) {
                showResults(context);
              });
            }
          },
          child: ListTile(
            leading: Container(
              height: 40,
              width: 40,
              // child: CachedNetworkImage(
              //   imageUrl: aa[index].userpic,
              //   placeholder: (context, url) => Center(
              //       child: Container(
              //           height: 10,
              //           width: 10,
              //           child: new CircularProgressIndicator(
              //             strokeWidth: 2,
              //           ))),
              //   errorWidget: (context, url, error) => new Icon(Icons.error),
              // ),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage(aa[index].userpic),
                      fit: BoxFit.cover)),
            ),
            title: RichText(
              text: TextSpan(
                  text: aa[index].username.substring(0, query.length),
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: aa[index].username.substring(query.length),
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
      itemCount: aa.length,
    );
  }
}

// setsearched(BuildContext context,String query) {
//   //  shopItems = [];
//   print("hii");
//   if (query != "") {
//     shopItems.forEach((i) {
//       // ignore: unnecessary_statements
//      for(int j=0;j<shopItems.length;j++)
//       print(shopItems[j].itemName);

//       if (i.itemName.startsWith(query.toUpperCase()) == false ||
//           i.itemName.startsWith(query) == false) {
//         shopItems..remove(i);

//       }

//       for(int j=0;j<shopItems.length;j++)
//       print(shopItems[j].itemName);

//       // if (i.phonenumber.startsWith(query)) aa.add(i.phonenumber);
//     });

//     Navigator.pushNamed(context, SearchedHomePage.routename);

//   }
// }

Future<void> setsearched(String query) async {
  //  shopItems = [];
  final List<FetchedAllUser> loadedUsers = [];
  int len;
  await Firestore.instance
      .collection("Users")
      .where("name", isEqualTo: query)

      // ignore: deprecated_member_use
      .getDocuments()
      .then((value) => {
            len = value.documents.length,
            if (len > 0)
              {
                loadedUsers.add(FetchedAllUser(
                  userEmail: value.documents[0]["email"],
                  followers: value.documents[0]["Followers"],
                  following: value.documents[0]["Following"],
                  posts: value.documents[0]["Posts"],
                  userUid: value.documents[0]["useruid"],
                  userage: value.documents[0]["age"],
                  username: value.documents[0]["name"],
                  userpic: value.documents[0]["userimage"],
                  blocked: value.documents[0]["Blocked"],
                  website: value.documents[0]["Website"],
                  bio: value.documents[0]["Bio"],
                  docid: value.documents[0].documentID,
                )),
              },
            searchedUsers = loadedUsers
          });
}
