import 'dart:io';
import 'dart:async';
//import 'package:provider/provider.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/admin/image_capture.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
//import 'package:shoppingapp2/services/authservice.dart';
//import 'package:testapp1/admin/image_capture.dart';
//import 'package:shoppingapp2/services/main_service.dart';
import 'package:shoppingapp2/services/mainservice.dart';

class AddProduct extends StatefulWidget {
  static const String id = 'AddProduct';

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String name, description, category = 'Saree';
  // price,
  // discount, category = 'Saree';
  num price, discount, quantity;

  GlobalKey<FormState> _globalFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  bool _isUploading = false;
  //List<Asset> _images;
  Map<int, Asset> map;
  Map<int, File> filemap;
  Asset img;
  var image;
  String path;
  File file;
  List<File> imageFiles;
  bool _uploadstatus = false;
  Color pickerColor = Color(0xff443a49);
  Color currentColor1 = Colors.white;
  Color currentColor2 = Colors.white;
  Color currentColor3 = Colors.white;
  Color currentColor4 = Colors.white;
  Color pickedColor;
  bool _s = false;
  bool _l = false;
  bool _m = false;
  bool _xl = false;
  List<String> colors = [];
  List<String> sizes = [];
  @override
  void initState() {
    super.initState();
    colors.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainService>(
      builder: (BuildContext context, Widget child, MainService model) {
        print(model.imageFileList);
        imageFiles = model.imageFileList;
        return SafeArea(
          child: Scaffold(
            key: _scaffoldStateKey,
            body: ListView(
              children: <Widget>[
                SizedBox(height: 20.0),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 130.0,
                    ),
                    Text(
                      'Add Product',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Form(
                      key: _globalFormKey,
                      child: ListView(
                        children: <Widget>[
                          ScopedModelDescendant<MainService>(
                            builder: (BuildContext context, Widget child,
                                MainService model) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, ImageCapture.id);
                                },
                                child: imageFiles.length == 0
                                    ? Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 90.0),
                                        height: 190.0,
                                        width: 40.0,
                                        decoration: BoxDecoration(
                                          color: Color(myyellow),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          // image: DecorationImage(
                                          //     image: AssetImage(camera),
                                          //     fit: BoxFit.cover),
                                        ),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 60.0,
                                        ),
                                      )
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        height: 190.0,
                                        width: double.infinity,
                                        child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: imageFiles.length,
                                            itemBuilder: (context, index) {
                                              return Card(
                                                child: Container(
                                                  height: 190.0,
                                                  width: 190,
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            imageFiles[index]),
                                                        fit: BoxFit.cover),
                                                  ),
                                                  //child: Text('data'),
                                                ),
                                              );
                                            }),
                                      ),
                              );
                            },
                          ),
                          SizedBox(height: 20.0),
                          _buildTextField(
                            'Product Name',
                          ),
                          _buildTextField(
                            'Product Description',
                          ),
                          _dropDownData(),
                          _buildTextField(
                            'Product price',
                          ),
                          _buildTextField(
                            'Product discount',
                          ),
                          _buildTextField(
                            'Product quantity',
                          ),
                          SizedBox(height: 20.0),
                          category != 'Saree'
                              ? Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 30.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Choose color',
                                        style: TextStyle(
                                          fontFamily: 'Nexa',
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          colors.clear();
                                          setState(() {
                                            colors.clear();
                                            currentColor1 = Colors.white;
                                            currentColor2 = Colors.white;
                                            currentColor3 = Colors.white;
                                            currentColor4 = Colors.white;
                                          });
                                        },
                                        child: Text(
                                          'Clear All',
                                          style: TextStyle(
                                              fontFamily: 'Nexa',
                                              fontSize: 12.0,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ))
                              : Text(''),
                          category != 'Saree'
                              ? SizedBox(height: 10.0)
                              : SizedBox(height: 0.0),
                          category != 'Saree'
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: GestureDetector(
                                        onTap: () {
                                          return buildShowDialog(
                                              context, 'currentColor1');
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: currentColor1,
                                          radius: 28.0,
                                          //child: Icon(Icons.check),
                                        ),
                                      ),
                                      radius: 30.0,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: GestureDetector(
                                        onTap: () {
                                          return buildShowDialog(
                                              context, 'currentColor2');
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: currentColor2,
                                          radius: 28.0,
                                          // child: Icon(Icons.check),
                                        ),
                                      ),
                                      radius: 30.0,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: GestureDetector(
                                        onTap: () {
                                          return buildShowDialog(
                                              context, 'currentColor3');
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: currentColor3,
                                          radius: 28.0,
                                          //child: Icon(Icons.check),
                                        ),
                                      ),
                                      radius: 30.0,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: GestureDetector(
                                        onTap: () {
                                          return buildShowDialog(
                                              context, 'currentColor4');
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: currentColor4,
                                          radius: 28.0,
                                          //child: Icon(Icons.check),
                                        ),
                                      ),
                                      radius: 30.0,
                                    ),
                                  ],
                                )
                              : Text(''),
                          // category != 'Saree'
                          //     ?

                          //: Text(''),
                          category != 'Saree'
                              ? SizedBox(height: 10.0)
                              : SizedBox(height: 0.0),
                          category != 'Saree'
                              ? Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      //SizedBox(width: 10.0,),
                                      Text(
                                        'S',
                                        style: TextStyle(fontFamily: 'Nexa'),
                                      ),
                                      Checkbox(
                                        value: _s,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _s = value;
                                            if (_s) {
                                              sizes.add('S');
                                            }
                                            if (_s == false) {
                                              sizes.remove('S');
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        'M',
                                        style: TextStyle(fontFamily: 'Nexa'),
                                      ),
                                      Checkbox(
                                        value: _m,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _m = value;
                                            if (_m) {
                                              sizes.add('M');
                                            }
                                            if (_m == false) {
                                              sizes.remove('M');
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        'L',
                                        style: TextStyle(fontFamily: 'Nexa'),
                                      ),
                                      Checkbox(
                                        value: _l,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _l = value;
                                            if (_l) {
                                              sizes.add('L');
                                            }
                                            if (_l == false) {
                                              sizes.remove('L');
                                            }
                                          });
                                        },
                                      ),
                                      Text(
                                        'XL',
                                        style: TextStyle(fontFamily: 'Nexa'),
                                      ),
                                      Checkbox(
                                        value: _xl,
                                        onChanged: (bool value) {
                                          setState(() {
                                            _xl = value;
                                            if (_xl) {
                                              sizes.add('XL');
                                            }
                                            if (_xl == false) {
                                              sizes.remove('XL');
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : Text(''),
                          SizedBox(height: 20.0),
                          ScopedModelDescendant<MainService>(
                            builder: (BuildContext context, Widget child,
                                MainService model) {
                              return GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      _isUploading = true;
                                    });
                                    bool _status =
                                        await onSubmitUpload(model, context);

                                    setState(() {
                                      _uploadstatus = _status;
                                    });

                                    setState(() {
                                      _isUploading = false;
                                    });
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30.0),
                                    height: 60.0,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        color: Color(myyellow)),
                                    child: Center(
                                        child: _isUploading
                                            ?
                                            // _uploadstatus
                                            //     ? Icon(
                                            //         Icons.check_circle_outline,
                                            //         color: Colors.white,
                                            //       )

                                            SpinKitRing(
                                                lineWidth: 2,
                                                size: 18,
                                                color: Colors.white,
                                                //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 60)),
                                              )
                                            : Text(
                                                'Upload Product',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.0,
                                                    fontFamily: 'Nexa',
                                                    fontWeight:
                                                        FontWeight.normal),
                                              )),
                                  )

                                  // UploadButton(
                                  //   bText: 'Upload',
                                  //   isUploading: _isUploading,
                                  // ),

                                  );
                            },
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future buildShowDialog(BuildContext context, String text) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Color currentColor;
        return AlertDialog(
          title: Text('Choose Color'),
          content: Container(
            height: 150.0,
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                currentColor = color;
              },

              showLabel: false,
              enableAlpha: false,
              //colorPickerWidth: 300.0,
              pickerAreaHeightPercent: 0.2,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Set Color'),
              onPressed: () {
                setState(() {
                  if (text == 'currentColor1') {
                    currentColor1 = currentColor;
                  }
                  if (text == 'currentColor2') {
                    currentColor2 = currentColor;
                  }
                  if (text == 'currentColor3') {
                    currentColor3 = currentColor;
                  }
                  if (text == 'currentColor4') {
                    currentColor4 = currentColor;
                  }
                });
                colors.add(currentColor.toString());
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> onSubmitUpload(MainService model, BuildContext context) async {
    bool status = false;
    if (_globalFormKey.currentState.validate()) {
      _globalFormKey.currentState.save();
      print('Name: $name');
      print('Description: $description');
      print('price: $price');
      print('discount: $discount');
      print('upload pressed');
      print('category: $category');
      // print('currentColor1: $currentColor1');
      // print('currentColor2: $currentColor2');
      // print('currentColor3: $currentColor3');
      // print('currentColor4: $currentColor4');
      // print('small: $_s');
      // print('medium: $_m');
      // print('large: $_l');
      // print('xl: $_xl');
      print('colors: $colors');
      print('sizes:$sizes');

      //call the firebase method
      status = await model.uploadAllProductDataToFirebase(
          model.imageFileList,
          name,
          description,
          price,
          discount,
          quantity,
          colors,
          sizes,
          category);
    }
    return status;
  }

  Widget _buildTextField(String sareeText) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: TextFormField(
        decoration: InputDecoration(
            labelText: sareeText,
            hoverColor: Colors.blueAccent,
            labelStyle: TextStyle(fontFamily: 'Nexa', fontSize: 12.0)),
        maxLines: 1,
        textInputAction: TextInputAction.next,
        style: TextStyle(fontFamily: 'Nexa', fontSize: 12.0),
        keyboardType: (sareeText == 'Product price') ||
                (sareeText == 'Product discount') ||
                (sareeText == 'Product quantity')
            ? TextInputType.number
            : TextInputType.text,
        validator: (String value) {
          //var errorMsg = '';
          if (value.isEmpty && sareeText == 'Product Name') {
            return 'Product name cannot be empty';
          }
          if (value.isEmpty && sareeText == 'Product Description') {
            return 'Product Description cannot be empty';
          }
          if (value.isEmpty && sareeText == 'Product price') {
            return 'Product price cannot be empty';
          }
          if (value.isNotEmpty && sareeText == 'Product price') {
            try {
              num val = num.parse(value.trim());
            } catch (e) {
              return 'Invalid Price value';
            }
          }
          if (value.isNotEmpty && sareeText == 'Product discount') {
            try {
              num val = num.parse(value.trim());
            } catch (e) {
              return 'Invalid Discount value';
            }
          }
          if (value.isNotEmpty && sareeText == 'Product quantity') {
            try {
              num val = num.parse(value.trim());
            } catch (e) {
              return 'Invalid quantity value';
            }
          }

          //return errorMsg;
        },
        onSaved: (String value) {
          if (sareeText == 'Product Name') {
            name = value.trim();
          }
          if (sareeText == 'Product Description') {
            description = value.trim();
          }
          if (sareeText == 'Product price') {
            price = num.parse(value.trim());
          }
          if (sareeText == 'Product discount') {
            discount = num.parse(value.trim());
          }
          if (sareeText == 'Product quantity')
            quantity = num.parse(value.trim());
        },
      ),
    );
  }

  Widget _dropDownData() {
    //String category1 = 'Sarees';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      child: DropdownButton<String>(
          value: category,
          items: <String>['Saree', 'Blouse', 'Trouser', 'Top']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          icon: Icon(Icons.arrow_downward),
          iconSize: 20.0,
          elevation: 10,
          style: TextStyle(
              color: Colors.black54, fontSize: 12.0, fontFamily: 'Nexa'),
          //   underline: Container(
          //   height: 2,
          //   color: Colors.grey,
          // ),
          onChanged: (String newvalue) {
            setState(() {
              category = newvalue;
            });
          }),
    );
  }
}

class UploadButton extends StatefulWidget {
  final String bText;
  final bool isUploading;
  UploadButton({this.bText, this.isUploading});

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0),
      height: 60.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: Color(myyellow)),
      child: Center(
          child: widget.isUploading
              ? SpinKitRing(
                  lineWidth: 2,
                  size: 18,
                  color: Colors.white,
                  //controller: AnimationController(vsync: this, duration: const Duration(milliseconds: 60)),
                )
              : Text(
                  widget.bText,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontFamily: 'Nexa',
                      fontWeight: FontWeight.bold),
                )),
    );
  }
}
