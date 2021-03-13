import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
//import 'package:flutter/services.dart';
//import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp2/admin/add_products_admin.dart';
import 'package:shoppingapp2/admin/upload_history.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:shoppingapp2/admin/add_product_admin.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/services/mainservice.dart';
//import 'package:shoppingapp2/views/authentication_view.dart';
import 'package:shoppingapp2/views/favourites.dart';
import 'package:shoppingapp2/views/product_view.dart';
//import 'package:shoppingapp2/widgets/signoutbox.dart';

class MyDrawer extends StatefulWidget {
  final MainService model;
  MyDrawer({this.model});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  AppUser user;

  @override
  void initState() {
    super.initState();
  }

  getUser(BuildContext context) {
    user = Provider.of<AppUser>(context);
  }

  @override
  Widget build(BuildContext context) {
    //AppUser user = ;
    getUser(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          children: <Widget>[
            Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) =>
                  (user.username == 'Madhu_Admin') ||
                  (user.username == 'Sunny_Admin'),
              widgetBuilder: (BuildContext context) =>
                  AdminDrawerWidgets(user: user),
              fallbackBuilder: (BuildContext context) =>
                  UserDrawerWidgets(user: user),
            )
            //UserDrawerWidgets(user: user),
          ],
        ),
      ),
    );
  }
}

class UserDrawerWidgets extends StatefulWidget {
  const UserDrawerWidgets({
    Key key,
    @required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  _UserDrawerWidgetsState createState() => _UserDrawerWidgetsState();
}

class _UserDrawerWidgetsState extends State<UserDrawerWidgets> {
  bool _isLogoff = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //User widgets...
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              '${widget.user.username}',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
        //Divider(color: Colors.grey),

        // user tools...
        Container(
          //padding: EdgeInsets.symmetric(horizontal: 55.0),
          child: ExpansionTile(
            leading: Icon(
              Icons.category,
              color: Colors.blueAccent,
            ),
            title: Text('Categories'),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDisplayPage(
                              categoryname:
                                  EnumToString.parse(Categories.Saree),
                              headerimage: saree5,
                            )));
                  },
                  child: ListTile(
                    //leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                    title: Text('Sarees'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDisplayPage(
                              categoryname: EnumToString.parse(Categories.Top),
                              headerimage: tops,
                            )));
                  },
                  child: ListTile(
                    //leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                    title: Text('Tops'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDisplayPage(
                              categoryname:
                                  EnumToString.parse(Categories.Blouse),
                              headerimage: blouse,
                            )));
                  },
                  child: ListTile(
                    //leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                    title: Text('Blouse'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDisplayPage(
                              categoryname:
                                  EnumToString.parse(Categories.Trouser),
                              headerimage: trousers,
                            )));
                  },
                  child: ListTile(
                    //leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                    title: Text('Trousers'),
                  ),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.shopping_basket, color: Colors.blueAccent),
            title: Text('Order History'),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavouritesView()));
          },
          child: ListTile(
            leading: Icon(Icons.favorite, color: Colors.blueAccent),
            title: Text('My Favourites'),
          ),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.home, color: Colors.blueAccent),
            title: Text('My billing Address'),
          ),
        ),
      ],
    );
  }
}

class AdminDrawerWidgets extends StatefulWidget {
  const AdminDrawerWidgets({
    Key key,
    @required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  _AdminDrawerWidgetsState createState() => _AdminDrawerWidgetsState();
}

class _AdminDrawerWidgetsState extends State<AdminDrawerWidgets> {
  //bool _isCatClicked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        //Admin widgets...
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              '${widget.user.username}',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ),
        //Divider(color: Colors.grey),

        //Admin tools...
        Container(
          //padding: EdgeInsets.symmetric(horizontal: 55.0),
          child: ExpansionTile(
            leading: Icon(
              Icons.cloud,
              color: Colors.blueAccent,
            ),
            title: Text('Admin Actions'),
            children: <Widget>[
              InkWell(
                onTap: () {
                 Navigator.pushNamed(context, AddProduct.id);
                },
                child: ListTile(
                  leading: Icon(Icons.add, color: Colors.blueAccent),
                  title: Text('Add a Product'),
                ),
              ),
              InkWell(
                onTap: () {
                  
                },
                child: ListTile(
                  leading: Icon(Icons.change_history, color: Colors.blueAccent),
                  title: Text('Update a Product'),
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  leading: Icon(Icons.clear, color: Colors.blueAccent),
                  title: Text('Delete a Product'),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context,UploadHistory.id);
                },
                child: ListTile(
                  leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                  title: Text('Upload History'),
                ),
              )
            ],
          ),
        ),

        // user tools...
        Container(
          //padding: EdgeInsets.symmetric(horizontal: 55.0),
          child: ExpansionTile(
            leading: Icon(
              Icons.category,
              color: Colors.blueAccent,
            ),
            title: Text('Categories'),
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDisplayPage(
                              categoryname:
                                  EnumToString.parse(Categories.Saree),
                              headerimage: saree5,
                            )));
                  },
                  child: ListTile(
                    //leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                    title: Text('Sarees'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDisplayPage(
                              categoryname: EnumToString.parse(Categories.Top),
                              headerimage: tops,
                            )));
                  },
                  child: ListTile(
                    //leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                    title: Text('Tops'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDisplayPage(
                              categoryname:
                                  EnumToString.parse(Categories.Blouse),
                              headerimage: blouse,
                            )));
                  },
                  child: ListTile(
                    //leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                    title: Text('Blouse'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProductDisplayPage(
                              categoryname:
                                  EnumToString.parse(Categories.Trouser),
                              headerimage: trousers,
                            )));
                  },
                  child: ListTile(
                    //leading: Icon(Icons.arrow_upward, color: Colors.blueAccent),
                    title: Text('Trousers'),
                  ),
                ),
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.shopping_basket, color: Colors.blueAccent),
            title: Text('Order History'),
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => FavouritesView()));
          },
          child: ListTile(
            leading: Icon(Icons.favorite, color: Colors.blueAccent),
            title: Text('My Favourites'),
          ),
        ),
        InkWell(
          onTap: () {},
          child: ListTile(
            leading: Icon(Icons.home, color: Colors.blueAccent),
            title: Text('My billing Address'),
          ),
        ),
      ],
    );
  }
}
