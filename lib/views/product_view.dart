import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/searchservice.dart';
import 'package:shoppingapp2/views/cart.dart';
import 'package:shoppingapp2/views/homepage_view.dart';
import 'package:shoppingapp2/widgets/mydrawer.dart';
import 'package:shoppingapp2/widgets/prod_list_widget.dart';
//import 'package:shoppingapp2/widgets/product_card.dart';

class ProductDisplayPage extends StatefulWidget {
  static String id = 'productpage';

  final String categoryname;
  final String headerimage;
  ProductDisplayPage({this.categoryname, this.headerimage});

  @override
  _ProductDisplayPageState createState() => _ProductDisplayPageState();
}

class _ProductDisplayPageState extends State<ProductDisplayPage>
    with TickerProviderStateMixin {
  //double _height = 200.0;
  AnimationController _controller;
  Animation<double> tween;
  num _count = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    CurvedAnimation _curve =
        CurvedAnimation(parent: _controller, curve: Curves.decelerate);
    tween = Tween<double>(begin: 500, end: 60).animate(_curve)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
    print('dispose from cat');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categoryname == 'Saree') {}
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey.shade300,
          iconTheme: new IconThemeData(color: Colors.black38),
          flexibleSpace: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.home),
                  onPressed: () {
                    Navigator.pushNamed(context, HomePage.id);
                  }),
              SizedBox(width: 40.0),
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
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
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
              )

              // IconButton(
              //     icon: Icon(Icons.shopping_cart),
              //     onPressed: () {
              //       Navigator.pushNamed(context, ShoppingCart.id);
              //     }),
            ],
          ),
        ),
        endDrawer: MyDrawer(),
        body: Container(
          //padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(widget.headerimage), fit: BoxFit.cover),
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 100.0),
                  child: Text(
                    widget.categoryname,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 30.0,
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: tween.value,
              ),
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.only(top: 40.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0))),
                  child: MyProdListView(
                    uid: Provider.of<AppUser>(context).uid,
                    viewType: ViewTypes.listView,
                    model: Product,
                    collection: EnumToString.parse(CollectionTypes.sarees),
                    category: widget.categoryname,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
