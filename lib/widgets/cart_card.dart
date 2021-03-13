import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/cart_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/mainservice.dart';

class CartCard extends StatefulWidget {
  final Cart cart;
  CartCard({
    this.cart,
  });

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  //String quan = quantity;
  int _quantity;
  double _price;
  Map<String, Cart> product;
  String docId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _quantity = widget.cart.quantity;
    _price = widget.cart.price.toDouble();
    return ScopedModelDescendant<MainService>(
      builder: (BuildContext context, Widget child, MainService model) {
        AppUser user = Provider.of<AppUser>(context);
        //-> CALL ORIGINAL PRODUCT PRICE HERE--->
        //model.
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<Map<String, Cart>>(
            future: AuthService().updateCartCard(user),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, Cart>> snapshot) {
              Widget futureChild;

              if (snapshot.hasData) {
                product = snapshot.data;
                futureChild = Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 5.0,
                  color: Color(mywhite1),
                  child: Slidable(
                    actionPane:
                        IconButton(icon: Icon(Icons.delete), onPressed: null),
                    child: Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 120,
                            width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0)),
                              image: DecorationImage(
                                  image: NetworkImage(widget.cart.imageList[0]),
                                  fit: BoxFit.cover),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${widget.cart.name}',
                                style: TextStyle(
                                  fontFamily: 'Nexa',
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Sizes:',
                                    style: TextStyle(
                                      fontFamily: 'Nexa',
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Row(
                                    children: widget.cart.sizes
                                        .map((item) => Text(
                                              '$item',
                                              style: TextStyle(
                                                fontFamily: 'Nexa',
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    'Colors:',
                                    style: TextStyle(
                                      fontFamily: 'Nexa',
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  Row(
                                      children: widget.cart.colors
                                          .map((color) => _colorWidget(color))
                                          .toList()),
                                ],
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                '₹ ${(_price * _quantity).toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontFamily: 'Nexa',
                                    color: Color(myyellow),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(width: 50.0),
                          Column(
                            children: <Widget>[
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      // print(_quantity);

                                      setState(() {
                                        _quantity = _quantity + 1;
                                        // _price = _price * _quantity;
                                      });
                                      getDocId();
                                      model.uploadCart(_quantity, docId);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                '${_quantity}',
                                style: TextStyle(
                                  fontFamily: 'Nexa',
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(30.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      if (_quantity == 1) {
                                        getDocId();
                                        model.deleteUserCart(docId);
                                      } else {
                                        setState(() {
                                          if (_quantity > 1) {
                                            _quantity = _quantity - 1;
                                          }
                                        });
                                        getDocId();
                                        model.uploadCart(_quantity, docId);
                                      }
                                    },
                                    child: _quantity == 1
                                        ? Icon(
                                            Icons.delete,
                                            size: 20.0,
                                          )
                                        : Icon(
                                            Icons.remove,
                                            size: 20,
                                            color: Colors.black45,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
              } else {
                futureChild = Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinKitRing(
                    color: Color(myyellow),
                    lineWidth: 2.0,
                  ),
                );
              }

              return futureChild;
            },
          ),
        );
      },
    );
  }

  Widget _colorWidget(int color) {
    return Container(
      margin: EdgeInsets.only(left: 2.0),
      padding: EdgeInsets.only(left: 2.0),
      child: CircleAvatar(
        radius: 10,
        backgroundColor: Color(color),
      ),
    );
  }

  getDocId() {
    if (widget.cart.category != 'Saree') {
      product.forEach((key, value) {
        if ((value.name == widget.cart.name) &&
            (value.sizes[0] == widget.cart.sizes[0]) &&
            (value.colors[0] == widget.cart.colors[0])) {
          setState(() {
            docId = key;
          });
        }
      });
    } else {
      product.forEach((key, value) {
        if (value.name == widget.cart.name) {
          setState(() {
            docId = key;
          });
        }
      });
    }
  }
}
