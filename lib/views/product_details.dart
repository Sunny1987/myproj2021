import 'dart:ui';

import 'package:carousel_pro/carousel_pro.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/mainservice.dart';
import 'package:shoppingapp2/services/searchservice.dart';
import 'package:shoppingapp2/views/cart.dart';
import 'package:shoppingapp2/views/homepage_view.dart';
import 'package:shoppingapp2/views/product_pic_closeup.dart';
import 'package:shoppingapp2/widgets/mydrawer.dart';

class ProductDetailsPage extends StatefulWidget {
  static String id = 'productdetails';

  final bool isFav;
  final MainService model;
  final AppUser user;
  final Map<String, Favourites> map;
  final String docID;
  final Map<String, Product> prod_map;
  final Product product;
  final Favourites fav;

  ProductDetailsPage({
    this.product,
    this.fav,
    this.isFav,
    this.model,
    this.user,
    this.map,
    this.docID,
    this.prod_map,
  });

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> tween;
  int _quantity = 0;
  bool _isFav;
  String docId = '';
  num _count = 0;
  bool _status = false;
  bool _isUploading = false;
  bool _sizePickS = false;
  bool _sizePickM = false;
  bool _sizePickL = false;
  bool _sizePickXL = false;
  List<String> sizes = [];
  List<Color> colors = [];
  List<num> col = [];
  bool _isColor1 = false;
  bool _isColor2 = false;
  bool _isColor3 = false;
  bool _isColor4 = false;
  String col1 = '';
  String col2 = '';
  String col3 = '';
  String col4 = '';

  @override
  void initState() {
    super.initState();
    _isFav = widget.isFav;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    CurvedAnimation _curve =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    tween = Tween<double>(begin: 300, end: 0).animate(_curve)
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
  Widget build(BuildContext context) {
    if (widget.product != null) {
      widget.product.colors.forEach((valcol) {
        int index = widget.product.colors.indexOf(valcol);
        if (index == 0) {
          col1 = valcol;
        }
        if (index == 1) {
          col2 = valcol;
        }
        if (index == 2) {
          col3 = valcol;
        }
        if (index == 3) {
          col4 = valcol;
        }
      });
    } else {
      widget.fav.colors.forEach((valcol) {
        int index = widget.fav.colors.indexOf(valcol);
        if (index == 0) {
          col1 = valcol;
        }
        if (index == 1) {
          col2 = valcol;
        }
        if (index == 2) {
          col3 = valcol;
        }
        if (index == 3) {
          col4 = valcol;
        }
      });
    }
    AppUser user = Provider.of<AppUser>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
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
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return countwidget;
                },
              )
            ],
          ),
        ),
        endDrawer: MyDrawer(),
        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            //widget.imageList[0]
                            //widget.product.imageList[0]
                            widget.product != null
                                ? widget.product.imageList[0]
                                : widget.fav.imageList[0]),
                        fit: BoxFit.cover),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 2.0,
                      sigmaY: 2.0,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 300.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductCloseUp()));
                            },
                            child: Carousel(
                              boxFit: BoxFit.cover,
                              autoplay: false,
                              animationCurve: Curves.fastOutSlowIn,
                              animationDuration: Duration(milliseconds: 1000),
                              dotSize: 4.0,
                              dotIncreasedColor: Color(myyellow),
                              dotBgColor: Colors.transparent,
                              dotPosition: DotPosition.bottomCenter,
                              dotVerticalPadding: 10.0,
                              showIndicator: true,
                              indicatorBgPadding: 7.0,
                              images: (widget.product == null
                                      ? widget.fav.imageList
                                      : widget.product.imageList)
                                  .map((url) => Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                        Expanded(
                          // flex: 6,
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: tween.value,
                              ),
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(80.0),
                                        //topRight: Radius.circular(20.0)
                                      )),
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            // mainAxisAlignment:
                                            //     MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                  widget.product != null
                                                      ? '${widget.product.name}'
                                                      : '${widget.fav.name}'
                                                  //'${widget.product.name}'
                                                  ,
                                                  style: TextStyle(
                                                      fontFamily: 'Nexa',
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                  widget.product != null
                                                      ? '₹ ${widget.product.price.toStringAsFixed(2)}'
                                                      : '₹ ${widget.fav.price.toStringAsFixed(2)}'
                                                  //'${widget.product.price}'
                                                  ,
                                                  style: TextStyle(
                                                      fontFamily: 'Nexa',
                                                      fontSize: 12.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Material(
                                                  elevation: 3.0,
                                                  color: Colors.grey.shade200,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  child: IconButton(
                                                      icon: Icon(
                                                        _isFav
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        color: Color(myyellow),
                                                      ),
                                                      onPressed: () {
                                                        setState(() {
                                                          _isFav = !_isFav;
                                                          if (widget.map !=
                                                              null) {
                                                            widget.map.forEach(
                                                                (key, value) {
                                                              if (widget
                                                                      .product !=
                                                                  null) {
                                                                if (value.imageList[
                                                                        0] ==
                                                                    widget
                                                                        .product
                                                                        .imageList[0]) {
                                                                  docId = key;
                                                                }
                                                              } else {
                                                                if (value.imageList[
                                                                        0] ==
                                                                    widget.fav
                                                                            .imageList[
                                                                        0]) {
                                                                  docId = key;
                                                                }
                                                              }
                                                            });
                                                          }
                                                          if (widget.map ==
                                                              null) {
                                                            widget.prod_map
                                                                .forEach((key,
                                                                    value) {
                                                              if (widget
                                                                      .product !=
                                                                  null) {
                                                                if (value.imageList[
                                                                        0] ==
                                                                    widget
                                                                        .product
                                                                        .imageList[0]) {
                                                                  docId = key;
                                                                }
                                                              } else {
                                                                if (value.imageList[
                                                                        0] ==
                                                                    widget.fav
                                                                            .imageList[
                                                                        0]) {
                                                                  docId = key;
                                                                }
                                                              }
                                                            });
                                                          }
                                                        });
                                                        widget.model
                                                            .firestoreAction(
                                                                _isFav,
                                                                docId,
                                                                widget.user.uid,
                                                                product: widget
                                                                    .product,
                                                                fav:
                                                                    widget.fav);
                                                      }))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Text(
                                                widget.product != null
                                                    ? widget.product.description
                                                    : widget.fav.description
                                                //'${widget.product.description}'
                                                ,
                                                style: TextStyle(
                                                  fontFamily: 'Nexa',
                                                  fontSize: 8,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                'Color',
                                                style: TextStyle(
                                                    fontFamily: 'Nexa',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),

                                          widget.product != null
                                              ? (widget.product.category ==
                                                          '${EnumToString.parse(Categories.Top)}') ||
                                                      (widget.product.category ==
                                                          '${EnumToString.parse(Categories.Trouser)}') ||
                                                      (widget.product.category ==
                                                          '${EnumToString.parse(Categories.Blouse)}')
                                                  ? Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: widget
                                                              .product.colors
                                                              .map((color) =>
                                                                  _colorWidget(
                                                                    color,
                                                                  ))
                                                              .toList(),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 30.0,
                                                            ),
                                                            Text(
                                                              'No Color Available',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nexa',
                                                                  fontSize:
                                                                      10.0),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    )
                                              : (widget.fav.category ==
                                                          '${EnumToString.parse(Categories.Top)}') ||
                                                      (widget.fav.category ==
                                                          '${EnumToString.parse(Categories.Trouser)}') ||
                                                      (widget.fav.category ==
                                                          '${EnumToString.parse(Categories.Blouse)}')
                                                  ? Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: widget
                                                              .fav.colors
                                                              .map((color) =>
                                                                  _colorWidget(
                                                                    color,
                                                                  ))
                                                              .toList(),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 30.0,
                                                            ),
                                                            Text(
                                                              'No Color Available',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nexa',
                                                                  fontSize:
                                                                      10.0),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                'Size',
                                                style: TextStyle(
                                                    fontFamily: 'Nexa',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),

                                          widget.product != null
                                              ? (widget.product.category ==
                                                          '${EnumToString.parse(Categories.Top)}') ||
                                                      (widget.product.category ==
                                                          '${EnumToString.parse(Categories.Trouser)}') ||
                                                      (widget.product.category ==
                                                          '${EnumToString.parse(Categories.Blouse)}')
                                                  ? Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: widget
                                                              .product.sizes
                                                              .map((size) =>
                                                                  _sizeWidget(
                                                                    size,
                                                                  ))
                                                              .toList(),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 30.0,
                                                            ),
                                                            Text(
                                                              'No Size Available',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nexa',
                                                                  fontSize:
                                                                      10.0),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                              : (widget.fav.category ==
                                                          '${EnumToString.parse(Categories.Top)}') ||
                                                      (widget.fav.category ==
                                                          '${EnumToString.parse(Categories.Trouser)}') ||
                                                      (widget.fav.category ==
                                                          '${EnumToString.parse(Categories.Blouse)}')
                                                  ? Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: widget
                                                              .fav.sizes
                                                              .map((size) =>
                                                                  _sizeWidget(
                                                                    size,
                                                                  ))
                                                              .toList(),
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    )
                                                  : Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: 30.0,
                                                            ),
                                                            Text(
                                                              'No Size Available',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Nexa',
                                                                  fontSize:
                                                                      10.0),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    ),

                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text('Quantity',
                                                  style: TextStyle(
                                                      fontFamily: 'Nexa',
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                          // SizedBox(
                                          //   height: 5.0,
                                          // ),
                                          Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              SizedBox(
                                                width: 30,
                                              ),
                                              Material(
                                                  elevation: 5.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  child: IconButton(
                                                      icon: Icon(Icons.add),
                                                      onPressed: () {
                                                        setState(() {
                                                          _quantity++;
                                                        });
                                                      })),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Text(
                                                '$_quantity',
                                                style: TextStyle(
                                                    fontFamily: 'Nexa',
                                                    fontSize: 18.0),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              Material(
                                                  elevation: 5.0,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                  child: IconButton(
                                                      icon: Icon(Icons.remove),
                                                      onPressed: () {
                                                        setState(() {
                                                          if (_quantity > 0) {
                                                            _quantity--;
                                                          }
                                                        });
                                                      }))
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                _isUploading = true;
                                              });
                                              var final_quantity =
                                                  calculateQuantity(_quantity);
                                              bool _stat =
                                                  await initiateCartUpload(
                                                      user, final_quantity);

                                              setState(() {
                                                _isUploading = false;
                                              });

                                              setState(() {
                                                _status = _stat;
                                              });
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.9,
                                              height: 60,
                                              child: Material(
                                                elevation: 5.0,
                                                color: Color(myyellow),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.shopping_basket,
                                                      color: Colors.white60,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    //_status?
                                                    _isUploading
                                                        ? SpinKitRing(
                                                            lineWidth: 2,
                                                            size: 18,
                                                            color: Colors.white,
                                                            //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 60)),
                                                          )
                                                        :
                                                        // _status
                                                        //     ?
                                                        Text(
                                                            'Add to Cart',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Nexa',
                                                                color: Colors
                                                                    .white60,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                    // : SnackBar(
                                                    //     content: null)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _colorWidget(String color) {
    String value = color.split('(')[1].split(')')[0];
    num myval = num.parse(value);
    //print(myval);

    return InkWell(
      onTap: () {
        setState(() {
          if (widget.product != null) {
            widget.product.colors.forEach((valcol) {
              if (color == valcol) {
                int index = widget.product.colors.indexOf(valcol);
                if (index == 0) {
                  _isColor1 = !_isColor1;
                  _isColor2 = false;
                  _isColor3 = false;
                  _isColor4 = false;

                  if (_isColor1) {
                    col.clear();
                    col.add(myval);
                  }
                  if (_isColor1 == false) {
                    col.clear();
                  }
                }
                if (index == 1) {
                  _isColor2 = !_isColor2;
                  _isColor1 = false;
                  _isColor3 = false;
                  _isColor4 = false;
                  if (_isColor2) {
                    col.clear();
                    col.add(myval);
                  }
                  if (_isColor2 == false) {
                    col.clear();
                  }
                }

                if (index == 2) {
                  _isColor3 = !_isColor3;
                  _isColor1 = false;
                  _isColor2 = false;
                  _isColor4 = false;

                  if (_isColor3) {
                    col.clear();
                    col.add(myval);
                  }
                  if (_isColor3 == false) {
                    col.clear();
                  }
                }

                if (index == 3) {
                  _isColor4 = !_isColor4;
                  _isColor1 = false;
                  _isColor2 = false;
                  _isColor3 = false;

                  if (_isColor4) {
                    col.clear();
                    col.add(myval);
                  }
                  if (_isColor4 == false) {
                    col.clear();
                  }
                }
              }
            });
          } else {
            widget.fav.colors.forEach((valcol) {
              if (color == valcol) {
                int index = widget.fav.colors.indexOf(valcol);
                if (index == 0) {
                  _isColor1 = !_isColor1;
                  _isColor2 = false;
                  _isColor3 = false;
                  _isColor4 = false;
                  if (_isColor1) {
                    col.clear();
                    col.add(myval);
                  }
                  if (_isColor1 == false) {
                    col.clear();
                  }
                }
                if (index == 1) {
                  _isColor2 = !_isColor2;
                  _isColor1 = false;
                  _isColor3 = false;
                  _isColor4 = false;
                  if (_isColor2) {
                    col.clear();
                    col.add(myval);
                  }
                  if (_isColor2 == false) {
                    col.clear();
                  }
                }

                if (index == 2) {
                  _isColor3 = !_isColor3;
                  _isColor1 = false;
                  _isColor2 = false;
                  _isColor4 = false;
                  if (_isColor3) {
                    col.clear();
                    col.add(myval);
                  }
                  if (_isColor3 == false) {
                    col.clear();
                  }
                }

                if (index == 3) {
                  _isColor4 = !_isColor4;
                  _isColor1 = false;
                  _isColor2 = false;
                  _isColor3 = false;
                  if (_isColor4) {
                    col.clear();
                    col.add(myval);
                  }
                  if (_isColor4 == false) {
                    col.clear();
                  }
                }
              }
            });
          }
        });

        print('col:$col');
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.0),
        padding: EdgeInsets.only(left: 10.0),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Color(myval),
          child: _isColor1 && color == col1
              ? Center(
                  child: Icon(
                    Icons.check,
                    size: 12.0,
                    color: Colors.white,
                  ),
                )
              : _isColor2 && color == col2
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 12.0,
                        color: Colors.white,
                      ),
                    )
                  : _isColor3 && color == col3
                      ? Center(
                          child: Icon(
                          Icons.check,
                          size: 12.0,
                          color: Colors.white,
                        ))
                      : _isColor4 && color == col4
                          ? Center(
                              child: Icon(
                              Icons.check,
                              size: 12.0,
                              color: Colors.white,
                            ))
                          : Text(''),
        ),
      ),
    );
  }

  Widget _sizeWidget(String sizeText) {
    return InkWell(
      onTap: () {
        setState(() {
          if (sizeText == 'S') {
            _sizePickS = !_sizePickS;
            _sizePickM = false;
            _sizePickL = false;
            _sizePickXL = false;

            if (_sizePickS) {
              sizes.clear();
              sizes.add('S');
            }
            if (_sizePickS == false) {
              sizes.clear();
            }
          }
          if (sizeText == 'M') {
            _sizePickM = !_sizePickM;
            _sizePickS = false;
            _sizePickL = false;
            _sizePickXL = false;
            if (_sizePickM) {
              sizes.clear();
              sizes.add('M');
            }
            if (_sizePickM == false) {
              sizes.clear();
            }
          }
          if (sizeText == 'L') {
            _sizePickL = !_sizePickL;
            _sizePickS = false;
            _sizePickM = false;
            _sizePickXL = false;
            if (_sizePickL) {
              sizes.clear();
              sizes.add('L');
            }
            if (_sizePickL == false) {
              sizes.clear();
            }
          }
          if (sizeText == 'XL') {
            _sizePickXL = !_sizePickXL;
            _sizePickS = false;
            _sizePickM = false;
            _sizePickL = false;

            if (_sizePickXL) {
              sizes.clear();
              sizes.add('XL');
            }
            if (_sizePickXL == false) {
              sizes.clear();
            }
          }
        });
        print('sizes: $sizes');
      },
      child: Container(
        margin: EdgeInsets.only(left: 10.0),
        padding: EdgeInsets.only(left: 10.0),
        child: CircleAvatar(
          backgroundColor: Colors.red.shade300,
          radius: 24.0,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: _sizePickS && sizeText == 'S'
                ? Center(
                    child: Icon(
                      Icons.check,
                      size: 10.0,
                      color: Colors.white,
                    ),
                  )
                : _sizePickM && sizeText == 'M'
                    ? Center(
                        child: Icon(
                          Icons.check,
                          size: 12.0,
                          color: Colors.white,
                        ),
                      )
                    : _sizePickL && sizeText == 'L'
                        ? Center(
                            child: Icon(
                              Icons.check,
                              size: 12.0,
                              color: Colors.white,
                            ),
                          )
                        : _sizePickXL && sizeText == 'XL'
                            ? Center(
                                child: Icon(
                                  Icons.check,
                                  size: 12.0,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                sizeText,
                                style: TextStyle(
                                    fontFamily: 'Nexa',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.white),
                              ),
          ),
        ),
      ),
    );
  }

  int calculateQuantity(int _quantity) {
    var final_quantity = 0;

    if (_quantity == 0) {
      final_quantity = 1;
    } else {
      final_quantity = _quantity;
    }

    return final_quantity;
  }

  Future<bool> initiateCartUpload(AppUser user, int final_quantity) async {
    bool _status = false;

    if (widget.product != null) {
      if (widget.product.category == 'Saree') {
        _status = await widget.model
            .uploadUserCart(user.uid, final_quantity, sizes, col,
                //docId,
                product: widget.product,
                fav: widget.fav);
      } else {
        if (col.length == 1 && sizes.length == 1) {
          _status = await widget.model
              .uploadUserCart(user.uid, final_quantity, sizes, col,
                  //docId,
                  product: widget.product,
                  fav: widget.fav);
        }
      }
    } else {
      if (widget.fav.category == 'Saree') {
        _status = await widget.model
            .uploadUserCart(user.uid, final_quantity, sizes, col,
                //docId,
                product: widget.product,
                fav: widget.fav);
      } else {
        if (col.length == 1 && sizes.length == 1) {
          _status = await widget.model
              .uploadUserCart(user.uid, final_quantity, sizes, col,
                  //docId,
                  product: widget.product,
                  fav: widget.fav);
        }
      }
    }

    return _status;
  }
}
