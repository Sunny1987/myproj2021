import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/searchservice.dart';
//import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/views/cart.dart';
import 'package:shoppingapp2/widgets/prod_list_widget.dart';

class FavouritesView extends StatefulWidget {
  static String id = 'favourites';
  @override
  _FavouritesViewState createState() => _FavouritesViewState();
}

class _FavouritesViewState extends State<FavouritesView>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> tween;
  num _count = 0;
  //String _collection = EnumToString();

  getUserCartCount(
    QuerySnapshot snapshot,
    AppUser user,
  ) async {
    var docs = await snapshot.documents;
    List list =
        docs.map((document) => Favourites.fromSnapshot(document)).toList();
    return list.length;
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    tween = Tween<double>(begin: 400, end: 60).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    AppUser user = Provider.of<AppUser>(context);
    final snapshot = await Firestore.instance
        .collection('user_cart')
        .where('id', isEqualTo: '${user.uid}')
        .getDocuments();
    num count = await getUserCartCount(snapshot, user);
    setState(() {
      _count = count;
    });
    print('cart count: $_count');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              )
            ],
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage(saree4), fit: BoxFit.cover),
          ),
          child: Column(
            children: <Widget>[
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 100.0),
                  child: Text(
                    'Favourites',
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
                    model: Favourites,
                    collection:
                        EnumToString.parse(CollectionTypes.user_favourites),
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
