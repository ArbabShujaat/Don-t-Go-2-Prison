// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class SearchedHomePage extends StatefulWidget {
//   static const routename = "/searchedhomepage";
//   @override
//   _SearchedHomePageState createState() => _SearchedHomePageState();
// }

// class _SearchedHomePageState extends State<SearchedHomePage> {
//   bool _isLoading = false;

//   ///////////////////////////////Did Change Dependencies/////////////////////////////////

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.grey[200],
//         child: Padding(
//           padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.only(top: 4),
//             child: StreamBuilder(
//                 stream: Firestore.instance
//                     .collection('Products')
//                     .where("title", isEqualTo: shopItems[0].title)
//                     .orderBy('datetime', descending: true)
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(
//                       child: CircularProgressIndicator(),
//                     );
//                   }
//                   final snapShotData = snapshot.data.documents;

//                   if (snapShotData.length == 0) {
//                     return Center(
//                       child: Text("No products added"),
//                     );
//                   }
//                   return GridView.builder(
//                       itemCount: snapShotData.length,
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         mainAxisSpacing: 10,
//                         crossAxisSpacing: 10,
//                         childAspectRatio: 0.6,
//                       ),
//                       itemBuilder: (context, index) {
//                         var product = snapShotData[index].data;

//                         //Create a product item to pass as arugument
//                         Product productdetail = Product(
//                           image: product['productimage'],
//                           price: product['productprice'],
//                           description: product['productdetails'],
//                           tax: product['producttax'],
//                           title: product['title'],
//                         );

//                         //-----------------------------------------

//                         return InkWell(
//                           onTap: () {
//                             // Navigator.push(
//                             //     context,
//                             //     MaterialPageRoute(
//                             //         builder: (context) => ProductDetails(
//                             //               product: productdetail,
//                             //             )));
//                           },
//                           child: Container(
//                               width: 160,
//                               height: 180,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(10.0)),
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.grey.withOpacity(0.6),
//                                         blurRadius: 10,
//                                         offset: Offset(0, 5))
//                                   ]),
//                               child: ListView(
//                                 children: <Widget>[
//                                   Container(
//                                     height:
//                                         MediaQuery.of(context).size.height / 6,
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(0.0),
//                                       child: ClipRRect(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                         child: CachedNetworkImage(
//                                           imageUrl: product['productimage'],
//                                           placeholder: (context, url) => Center(
//                                               child:
//                                                   new CircularProgressIndicator()),
//                                           errorWidget: (context, url, error) =>
//                                               new Icon(Icons.error),
//                                         ),
//                                         // child: Image(
//                                         //     image: NetworkImage(
//                                         //         product['productimage'])),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(2.0),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: <Widget>[
//                                         SizedBox(
//                                           width: 110.0,
//                                           child: AutoSizeText(
//                                             product['title'],
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                                 color: Colors.red,
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 20),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 60.0,
//                                           child: AutoSizeText(
//                                             "\$" + product['productprice'],
//                                             maxLines: 1,
//                                             style: TextStyle(
//                                                 color: Colors.grey,
//                                                 fontWeight: FontWeight.w500,
//                                                 fontSize: 20),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               )),
//                         );
//                       });
//                 }),
//           ),
//         ),
//       ),

// ////////////////////////////// Floating Action Button ////////////////////////////////////////////
//     );
//   }
// }
