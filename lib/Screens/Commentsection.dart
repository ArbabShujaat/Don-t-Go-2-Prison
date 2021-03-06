import 'package:design_app/Constants/constant.dart';
import 'package:design_app/Funtions.dart';
import 'package:design_app/Screens/stories.dart';
import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  TextEditingController comment = TextEditingController();
  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: orange,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  iconTheme: new IconThemeData(color: orange),
                  backgroundColor: Colors.white,
                ),
                body: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                          child: ListView.builder(
                              reverse: false,
                              itemCount: 25,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 50.0,
                                          height: 50.0,
                                          decoration: new BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: new AssetImage(
                                                      "assets/s.jpg"))),
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Flex(
                                          direction: Axis.horizontal,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                                padding: EdgeInsets.all(10.0),
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.7,
                                                ),
                                                decoration: BoxDecoration(
                                                    color: orange,
                                                    border: Border.all(
                                                        color: Colors.red),
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    30.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    30.0),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    30.0))),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Shoaib Salamat",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      "Very nice picture Too Good I just love this picture ",
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        // Text(
                                      ],
                                    ));
                              })),
                      Divider(
                        color: orange,
                      ),
                      new Padding(
                          padding: EdgeInsets.all(0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: orange,
                            ),
                            child: new Theme(
                                data: new ThemeData(
                                  primaryColor: orange,
                                  primaryColorDark: orange,
                                ),
                                child: TextFormField(
                                  controller: comment,
                                  onFieldSubmitted: (q) async {
                                    await addcomment(cmntdocid, comment.text,
                                        int.parse(cmntNumbers));
                                  },
                                  decoration: new InputDecoration(
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          Icons.comment,
                                          color: Colors.black,
                                        ),
                                        onPressed: () async {
                                          await addcomment(
                                              cmntdocid,
                                              comment.text,
                                              int.parse(cmntNumbers));

                                          int cmnts = int.parse(posts[indexcmnt]
                                                  .commentsNumber) +
                                              1;
                                          setState(() {
                                            posts[indexcmnt].commentsNumber =
                                                cmnts.toString();
                                          });
                                        }),
                                    hintText: "Add Commment",
                                    hintStyle: TextStyle(color: Colors.black),
                                    fillColor: orange,

                                    border: new OutlineInputBorder(
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                  style: new TextStyle(
                                    color: Colors.black,
                                    fontFamily: "Poppins",
                                  ),
                                )),
                          )),
                    ]))));
  }
}
