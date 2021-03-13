import 'dart:async';
import 'dart:ui';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:enum_to_string/enum_to_string.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
//import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
// import 'package:shoppingapp2/app_consts/app_var.dart';
// import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/views/product_details.dart';
//import 'package:shoppingapp2/widgets/product_card.dart';

import 'mainservice.dart';

class ProductSearch extends SearchDelegate<Product> {
  List list_name;
  List<Product> searchList;
  //List list_description;
  bool _isFav;
  Map<bool, Map<String, Favourites>> mymap;
  Map<String, Favourites> map;

  ProductSearch(this.list_name);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
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
    AppUser user = Provider.of<AppUser>(context);

    MainService model = MainService();
    return ListView.builder(
        itemCount: searchList.length,
        itemBuilder: (ctx, index) {
          return FutureBuilder<Map<bool, Map<String, Favourites>>>(
            future:
                AuthService().callFav(context, searchList[index].imageList[0]),
            builder: (BuildContext context,
                AsyncSnapshot<Map<bool, Map<String, Favourites>>> snapshot) {
              Widget futurechild;
              if (snapshot.hasData) {
                mymap = snapshot.data;
                mymap.forEach((key, value) {
                  _isFav = key;
                  map = value;
                });

                futurechild = InkWell(
                  onTap: () async {
                    var data = searchList[index];
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                              product: data,
                              isFav: _isFav,
                              model: model,
                              user: user,
                              map: map,
                            )));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
                    decoration: BoxDecoration(
                      color: Color(mywhite1),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 1.0),
                            blurRadius: 1.0,
                            color: Colors.grey)
                      ],
                      //borderRadius: BorderRadius.circular(10.0),
                    ),
                    width: double.infinity,
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 70,
                          width: 100,
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.only(
                            //     topLeft: Radius.circular(10.0),
                            //     bottomLeft: Radius.circular(10.0),
                            //     ),
                            image: DecorationImage(
                                image: NetworkImage(
                                    searchList[index].imageList[0]),
                                fit: BoxFit.fill),
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                searchList[index].name,
                                style: TextStyle(
                                  fontFamily: 'Nexa',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${searchList[index].price}',
                                style: TextStyle(
                                    fontFamily: 'Nexa',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                futurechild = Container(
                  width: 100.0,
                  height: 100.0,
                  child: Text('Some Error Occured'),
                );
              } else {
                futurechild = Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SpinKitRing(
                    lineWidth: 2,
                    size: 26,
                    color: Color(myyellow),
                  ),
                );
              }

              return futurechild;
            },
            //child: ,
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    num len = list_name.length;
    List sampleList = [];
    if (len > 0 && len < 4) {
      sampleList = list_name.sublist(1, len);
    } else if (len == 0) {
      sampleList = [];
    } else {
      sampleList = list_name.sublist(1, 4);
    }

    final suggestionList = query.isEmpty
        ? sampleList
        : list_name
            .where((element) =>
                element.toString().toLowerCase().contains(query.toLowerCase()))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
              onTap: () async {
                query = suggestionList[index].trim();
                searchList = await AuthService().getSearchResults(query);
                print(searchList.length);
                showResults(context);
              },
              leading: Icon(Icons.search),
              title: RichText(
                text: TextSpan(
                    text: suggestionList[index].substring(0, query.length),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                          text: suggestionList[index].substring(query.length),
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    ]),
                // children: [] Text(suggestionList[index])),
              ));
        });
  }
}
