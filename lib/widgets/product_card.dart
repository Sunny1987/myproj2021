import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/services/mainservice.dart';
import 'package:shoppingapp2/views/product_details.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  ProductCard({this.product});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFav = false;
  Map<String, Favourites> map;
  String docId = '';
  Map<String, Product> product_map;

  @override
  Widget build(BuildContext context) {
    AppUser user = Provider.of<AppUser>(context);

    return ScopedModelDescendant<MainService>(
      builder: (BuildContext context, Widget child, MainService model) {
        return FutureBuilder<Map<bool, Map<String, Favourites>>>(
          future: model.callFav(context, widget.product.imageList[0]),
          builder: (BuildContext context,
              AsyncSnapshot<Map<bool, Map<String, Favourites>>> snapshot) {
            Widget child;
            if (snapshot.hasData) {
              //product_map = snapshot.data;
              snapshot.data.forEach((key, value) {
                _isFav = key;
                map = value;
              });
              child = InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProductDetailsPage(
                            product: widget.product,
                            isFav: _isFav,
                            model: model,
                            user: user,
                            map: map,
                            prod_map: product_map,
                          )));
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  //padding: EdgeInsets.only(right: 10.0),
                  height: 200,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    image: DecorationImage(
                        image: NetworkImage(widget.product.imageList[0]
                            //widget.imageList[0]
                            ),
                        fit: BoxFit.cover),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        height: 60.0,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white38.withOpacity(0.9)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              '${widget.product.name}',
                              softWrap: true,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: 'Nexa',
                                fontSize: 12.0,
                                color: Color(myyellow),
                              ),
                            ),
                            Text(
                              '₹ ${(widget.product.price).toStringAsFixed(2)}',
                              
                              style: TextStyle(
                                  fontFamily: 'Nexa',
                                  fontSize: 12.0,
                                  color: Color(myyellow)),
                            ),
                            Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(30.0),
                              child: FutureBuilder<Map<String, Product>>(
                                future: model.getAllDocIds(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<Map<String, Product>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    product_map = snapshot.data;
                                  } else if (snapshot.hasError) {
                                    product_map = null;
                                  }

                                  return IconButton(
                                    icon: _isFav
                                        ? Icon(
                                            Icons.favorite,
                                            color: Color(myyellow),
                                          )
                                        : Icon(
                                            Icons.favorite_border,
                                            color: Color(myyellow),
                                          ),
                                    onPressed: () {
                                      setState(() {
                                        _isFav = !_isFav;
                                        if (map != null) {
                                          map.forEach((key, value) {
                                            if (value.imageList[0] ==
                                                widget.product.imageList[0]) {
                                              docId = key;
                                            }
                                          });
                                        }
                                        if (map == null) {
                                          product_map.forEach((key, value) {
                                            if (value.imageList[0] ==
                                                widget.product.imageList[0]) {
                                              docId = key;
                                            }
                                          });
                                        }
                                      });

                                      model.firestoreAction(
                                          _isFav, docId, user.uid,
                                          product: widget.product);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              child = Container(
                width: 100.0,
                height: 100.0,
                child: Text('Some Error Occured'),
              );
            } else {
              child = Padding(
                padding: const EdgeInsets.all(20.0),
                child: SpinKitRing(
                  lineWidth: 2,
                  color: Color(myyellow),
                ),
              );
            }

            return child;
          },
        );
      },
      //child: ,
    );
  }
}
