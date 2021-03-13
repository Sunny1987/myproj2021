import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/services/authservice.dart';
//import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/mainservice.dart';
import 'package:shoppingapp2/services/searchservice.dart';
import 'package:shoppingapp2/views/cart.dart';
import 'package:shoppingapp2/views/product_view.dart';
import 'package:shoppingapp2/widgets/category_card.dart';
import 'package:shoppingapp2/widgets/mydrawer.dart';
import 'package:shoppingapp2/widgets/special_card.dart';

class HomePage extends StatefulWidget {
  static String id = 'homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _scaffoldKey = new GlobalKey();
  num _count = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScopedModelDescendant<MainService>(
        builder: (BuildContext context, Widget child, MainService model) {
          return Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.grey.shade300,
              iconTheme: new IconThemeData(color: Colors.black38),
              flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () async {
                        final names = await AuthService().getProds();
                        showSearch(
                            context: context, delegate: ProductSearch(names));
                      }),
                  SizedBox(width: 40.0),
                  FutureBuilder<int>(
                    future: AuthService().getUserCartCount(context),
                    builder:
                        (BuildContext context, AsyncSnapshot<int> snapshot) {
                      Widget countwidget;
                      if (snapshot.hasData) {
                        _count = snapshot.data;
                        countwidget = Stack(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {
                                  Navigator.pushNamed(context, ShoppingCart.id);
                                }),
                            Positioned(
                              right: 7,
                              top: 5,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: new BoxDecoration(
                                  color: Color(myyellow),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '$_count',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontFamily: 'Nexa',
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        Stack(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {
                                  Navigator.pushNamed(context, ShoppingCart.id);
                                }),
                            Positioned(
                              right: 7,
                              top: 5,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: new BoxDecoration(
                                  color: Color(myyellow),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8,
                                      fontFamily: 'Nexa',
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        countwidget = Stack(
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.shopping_cart),
                                onPressed: () {
                                  Navigator.pushNamed(context, ShoppingCart.id);
                                }),
                            Positioned(
                              right: 7,
                              top: 5,
                              child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: new BoxDecoration(
                                    color: Color(myyellow),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 16,
                                    minHeight: 16,
                                  ),
                                  child: SpinKitRing(
                                    color: Colors.white,
                                    size: 8.0,
                                    lineWidth: 1,
                                  )),
                            ),
                          ],
                        );
                      }

                      return countwidget;
                    },
                  ),
                  SizedBox(width: 40.0),
                  IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () async {
                        await model.signOut();
                      }),
                ],
              ),
            ),
            endDrawer: MyDrawer(
              model: model,
            ),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container(
                        //padding: EdgeInsets.symmetric(horizontal: 20.0),
                        height: MediaQuery.of(context).size.width * 0.3,
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(dashboard), fit: BoxFit.cover),
                        ),
                        child: Center(
                          child: Text(
                            appname,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 22.0,
                              fontFamily: 'Nexa',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      //height: 200,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10.0),
                          Text(
                            'Categories',
                            style: TextStyle(
                                color: Colors.black38,
                                fontFamily: 'Nexa',
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10.0),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDisplayPage(
                                                    categoryname:
                                                        EnumToString.parse(
                                                            Categories.Saree),
                                                    headerimage: saree5,
                                                  )));
                                    },
                                    child: CategoryCard(
                                      productname: 'Saree',
                                      image: saree5,
                                    )),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDisplayPage(
                                                    categoryname:
                                                        EnumToString.parse(
                                                            Categories.Top),
                                                    headerimage: tops,
                                                  )));
                                    },
                                    child: CategoryCard(
                                        productname: 'Tops', image: tops)),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDisplayPage(
                                                    categoryname:
                                                        EnumToString.parse(
                                                            Categories.Blouse),
                                                    headerimage: blouse,
                                                  )));
                                    },
                                    child: CategoryCard(
                                      productname: 'Blouse',
                                      image: blouse,
                                    )),
                                InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDisplayPage(
                                                    categoryname:
                                                        EnumToString.parse(
                                                            Categories.Trouser),
                                                    headerimage: trousers,
                                                  )));
                                    },
                                    child: CategoryCard(
                                      productname: 'Trouser',
                                      image: trousers,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //SizedBox(height: 10.0,),
                  Expanded(
                      flex: 3,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: SpecialCard(),
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
