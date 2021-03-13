import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/cart_model.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/widgets/cart_card.dart';
import 'package:shoppingapp2/widgets/favourite_card.dart';
import 'package:shoppingapp2/widgets/product_card.dart';
//import 'package:testapp1/models/favoutites_model.dart';
// import 'package:testapp1/models/product_model.dart';
//import 'package:testapp1/widgets/product_card.dart';
//user_favourites

class MyProdListView extends StatefulWidget {
  @required
  final String uid;
  @required
  final ViewTypes viewType;
  @required
  final dynamic model;
  @required
  final String collection;
  final String category;
  MyProdListView(
      {this.uid, this.viewType, this.model, this.collection, this.category});

  @override
  _MyProdListViewState createState() => _MyProdListViewState();
}

class _MyProdListViewState extends State<MyProdListView> {
  Stream stream;

  void getStream() {
    if (widget.collection == 'user_favourites') {
      stream = Firestore.instance
          .collection('${widget.collection}')
          .where('id', isEqualTo: '${widget.uid}')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
    if (widget.collection == 'user_cart') {
      stream = Firestore.instance
          .collection('${widget.collection}')
          .where('id', isEqualTo: '${widget.uid}')
          .orderBy('createdAt', descending: true)
          .snapshots();
    }
    if (widget.collection == 'sarees') {
      if (widget.category != null) {
        stream = Firestore.instance
            .collection('${widget.collection}')
            .where('category', isEqualTo: '${widget.category}')
            .orderBy('createdAt', descending: true)
            .snapshots();
      }
    }
  }

  @override
  initState() {
    super.initState();
    getStream();
  }

  @override
  void dispose() {
    super.dispose();
    print('dispose fro my list');
  }

  // String _collection = EnumToString(widget.collection);
  @override
  Widget build(BuildContext context) {
    //print('index:${widget.index}');

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return SpinKitCubeGrid(
            color: Colors.grey,
          );
        } else {
          return Container(
              padding: EdgeInsets.only(right: 10.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: _buildSnapshot(context, snapshot.data.documents,
                  widget.viewType, widget.model, widget.category));
        }
      },
    );
  }
}

Widget _buildSnapshot(BuildContext context, List<DocumentSnapshot> snapshot,
    ViewTypes viewType, dynamic model, String category) {
  Widget widget;

  //for listview
  if (viewType == ViewTypes.listView) {
    widget = ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot
          .map((data) => _callProductCard(data, model, category))
          .toList(),
    );

    //for gridview
  } else if (viewType == ViewTypes.gridView) {
    widget = GridView.count(
      crossAxisCount: 2,
      children: snapshot
          .map((data) => _callProductCard(data, model, category))
          .toList(),
    );
  }

  return widget;
}

Widget _callProductCard(DocumentSnapshot data, dynamic model, String category) {
  Widget widget;

  if (model == Favourites) {
    final dataset = Favourites.fromSnapshot(data);
    widget = FavouriteCard(
      fav: dataset,
    );
  }
  if (model == Product) {
    final dataset = Product.fromSnapshot(data);
    widget = ProductCard(
      product: dataset,
    );
  }
  if (model == Cart) {
    final dataset = Cart.fromSnapshot(data);
    widget = CartCard(
      cart: dataset,
    );
  }

  return widget;
}
