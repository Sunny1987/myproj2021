import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
import 'package:shoppingapp2/models/appuser.dart';
import 'package:shoppingapp2/models/cart_model.dart';
import 'package:shoppingapp2/models/favourites_model.dart';
import 'package:shoppingapp2/models/product_model.dart';
// import 'package:shoppingapp2/services/mainservice.dart';
// import 'package:http/http.dart' as http;

//const String NoSuchUser = 'No such User';

enum Errors {
  No_Such_User,
  Invalid_Email_Format,
  Invalid_Email_Or_Password,
}

class AuthService extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  AppUser appuser;
  var errorMsg;
  bool _isFav = false;
  Map<String, Favourites> map;
  String docId = '';
  Map<String, Product> product_map;
  File _imageFile;
  List<Asset> _images;
  bool _isLoading = false;
  List<File> _imageFiles = [];

  AppUser _userFromFirebase(FirebaseUser user) {
    if (user != null) {
      AppUser appuser = AppUser(uid: user.uid);

      getUsersData(appuser);
      //getFavourites(appuser);
      return appuser;
    } else {
      return null;
    }
    //return user != null ? AppUser(uid: user.uid) : null;
    // return AppUser();
  }

  Future<AppUser> mySignIn(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('result from authservice: $result');
      FirebaseUser user = result.user;
      return _userFromFirebase(user);
    } on PlatformException catch (err) {
      getAuthError(err.message);
      return Future.value(null);
    } catch (e) {
      return Future.value(null);
    }
  }

  Stream<AppUser> get user {
    return _auth.onAuthStateChanged.map((user) => _userFromFirebase(user));
    //return _auth.currentUser().then((user) => _userFromFirebase(user)).asStream();
  }

  // Stream getStream() {
  //   final snapshot = Firestore.instance
  //       .collection('user_favourites')
  //       .where('id', isEqualTo: '${user.uid}')
  //       .getDocuments();

  // }

  Future<void> getAuthError(String msg) async {
    errorMsg = await msg;
  }

  Future<String> getError() async {
    //print(errorMsg);
    if (errorMsg.contains(
        'There is no user record corresponding to this identifier. The user may have been deleted')) {
      errorMsg = 'No such User';
      //errorMsg = Errors.No_Such_User.toString();
    } else if (errorMsg.contains('The email address is badly formatted')) {
      errorMsg = 'Please provide valid email address';
      //errorMsg = Errors.Invalid_Email_Format;
    } else if (errorMsg.contains(
        'The password is invalid or the user does not have a password')) {
      errorMsg = 'Invalid email id or password';
      //errorMsg = Errors.Invalid_Email_Or_Password.toString();
    }

    return errorMsg;
  }

  Future signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
      //return result;
    } catch (e) {
      print(e.toString());
      //return null;
    }
  }

  Future<bool> uploadUserCart(
      String uid, int quantity, List<String> sizes, List<num> colors,
      {Product product, Favourites fav}) async {
    //logic to check if the product already exists

    try {
      if (product == null && fav != null) {
        final snapshot = await Firestore.instance
            .collection(EnumToString.parse(CollectionTypes.user_cart))
            .where('id', isEqualTo: '${uid}')
            .getDocuments();

        bool status = snapshot.documents
            .map((element) => Cart.fromMap(element.data))
            .any((item) {
          bool mystatus = false;

          if (fav.category == 'Saree') {
            if (item.name == fav.name) {
              mystatus = true;
            }
          } else {
            if (item.name == fav.name) {
              if (item.colors[0] == colors[0]) {
                if (sizes.contains(item.sizes[0])) {
                  mystatus = true;
                }
              }
            }
          }

          return mystatus;
        });

        if (status) {
          String docId = '';
          int quant = 0;
          var docs = snapshot.documents;
          Map<String, Cart> cart = Map.fromIterable(docs,
              key: (doc) => doc.documentID,
              value: (doc) => Cart.fromSnapshot(doc));

          if (fav.category == 'Saree') {
            cart.forEach((key, value) async {
              if (value.name == fav.name) {
                docId = key;
                quant = value.quantity + quantity;
                await Firestore.instance
                    .collection(EnumToString.parse(CollectionTypes.user_cart))
                    .document(docId)
                    .updateData({
                  'quantity': quant,
                  //'sizes': sizes, 'colors': colors
                });
              }
            });
          } else {
            cart.forEach((key, data) async {
              if (data.name == fav.name) {
                if (data.colors[0] == colors[0]) {
                  if (sizes.contains(data.sizes[0])) {
                    docId = key;
                    quant = data.quantity + quantity;
                    await Firestore.instance
                        .collection(
                            EnumToString.parse(CollectionTypes.user_cart))
                        .document(docId)
                        .updateData({
                      'quantity': quant,
                      //'sizes': sizes, 'colors': colors
                    });
                  }
                }
              }
            });
          }
        } else {
          await Firestore.instance
              .collection(EnumToString.parse(CollectionTypes.user_cart))
              .document()
              .setData({
            'id': uid,
            'name': fav.name,
            'description': fav.description,
            'price': fav.price,
            'discount': fav.discount,
            'quantity': quantity,
            'sizes': sizes,
            'colors': colors,
            'category': fav.category,
            //'docId': docId,
            'imageList': fav.imageList,
            'createdAt': FieldValue.serverTimestamp()
          });
        }
      }

      if (product != null && fav == null) {
        final snapshot = await Firestore.instance
            .collection(EnumToString.parse(CollectionTypes.user_cart))
            .where('id', isEqualTo: '${uid}')
            .getDocuments();

        bool status = snapshot.documents
            .map((element) => Cart.fromMap(element.data))
            .any((item) {
          bool mystatus = false;

          if (product.category == 'Saree') {
            if (item.name == product.name) {
              mystatus = true;
            }
          } else {
            if (item.name == product.name) {
              if (item.colors[0] == colors[0]) {
                if (sizes.contains(item.sizes[0])) {
                  mystatus = true;
                }
              }
            }
          }

          return mystatus;
        });

        if (status) {
          String docId = '';
          int quant = 0;
          var docs = snapshot.documents;
          Map<String, Cart> cart = Map.fromIterable(docs,
              key: (doc) => doc.documentID,
              value: (doc) => Cart.fromSnapshot(doc));

          if (product.category == 'Saree') {
            cart.forEach((key, value) async {
              if (value.name == product.name) {
                docId = key;
                quant = value.quantity + quantity;
                await Firestore.instance
                    .collection(EnumToString.parse(CollectionTypes.user_cart))
                    .document(docId)
                    .updateData({
                  'quantity': quant,
                  //'sizes': sizes, 'colors': colors
                });
              }
            });
          } else {
            cart.forEach((key, data) async {
              if (data.name == product.name) {
                if (data.colors[0] == colors[0]) {
                  if (sizes.contains(data.sizes[0])) {
                    docId = key;
                    quant = data.quantity + quantity;
                    await Firestore.instance
                        .collection(
                            EnumToString.parse(CollectionTypes.user_cart))
                        .document(docId)
                        .updateData({
                      'quantity': quant,
                      //'sizes': sizes, 'colors': colors
                    });
                  }
                }
              }
            });
          }
        } else {
          await Firestore.instance
              .collection(EnumToString.parse(CollectionTypes.user_cart))
              .document()
              .setData({
            'id': uid,
            'name': product.name,
            'description': product.description,
            'price': product.price,
            'discount': product.discount,
            'quantity': quantity,
            'sizes': sizes,
            'colors': colors,
            'category': product.category,
            //'docId': docId,
            'imageList': product.imageList,
            'createdAt': FieldValue.serverTimestamp()
          });
        }
      }

      return Future.value(true);
    } catch (e) {
      print(e.toString());
      return Future.value(false);
    }
  }

  getUsersData(AppUser user) {
    Firestore.instance
        .collection(EnumToString.parse(CollectionTypes.users))
        .where('id', isEqualTo: '${user.uid}')
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((element) {
        //print(element.data['username']);
        user.username = element.data['username'];
      });
    });
  }

  void firestoreAction(bool isFav, String docId, String uid,
      {Product product, Favourites fav}) async {
    if (isFav) {
      if (fav == null && product != null) {
        await uploadUserFavourites(uid, product: product);
      }
      if (fav != null && product == null) {
        await uploadUserFavourites(uid, fav: fav);
      }
    } else {
      await deleteUserFavourites(docId);
    }
  }

  void uploadUserFavourites(String uid,
      {Product product, Favourites fav}) async {
    try {
      if (fav == null && product != null) {
        await Firestore.instance
            .collection(EnumToString.parse(CollectionTypes.user_favourites))
            .document()
            .setData({
          'id': uid,
          'name': product.name,
          'description': product.description,
          'price': product.price,
          'discount': product.discount,
          'imagelist': product.imageList,
          'quantity': product.quantity,
          'sizes': product.sizes,
          'colors': product.colors,
          'category': product.category,
          'createdAt': FieldValue.serverTimestamp()
        });
      }
      if (fav != null && product == null) {
        await Firestore.instance
            .collection(EnumToString.parse(CollectionTypes.user_favourites))
            .document()
            .setData({
          'id': uid,
          'name': fav.name,
          'description': fav.description,
          'price': fav.price,
          'discount': fav.discount,
          'imagelist': fav.imageList,
          'quantity': fav.quantity,
          'sizes': fav.sizes,
          'colors': fav.colors,
          'category': fav.category,
          'createdAt': FieldValue.serverTimestamp()
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteUserFavourites(String docId) async {
    await Firestore.instance
        .collection(EnumToString.parse(CollectionTypes.user_favourites))
        .document(docId)
        .delete();
  }

  Future<List<dynamic>> getProds() async {
    List names = [];
    final snapshot = await Firestore.instance
        .collection(EnumToString.parse(CollectionTypes.sarees))
        .getDocuments();
    names = await getProdList(snapshot);

    return names;
  }

  Future<List<dynamic>> getProdList(QuerySnapshot snapshot) async {
    var docs = await snapshot.documents;
    List name = [];

    List list = docs.map((document) => Product.fromSnapshot(document)).toList();

    list.forEach((document) {
      Product prod = document;
      name.add(prod.name);
      //list_description.add(fav.description);
    });

    return name;
  }

  Future getSearchResults(String query) async {
    var result = await Firestore.instance
        .collection(EnumToString.parse(CollectionTypes.sarees))
        .where('name', isEqualTo: '$query')
        .getDocuments();
    var docs = result.documents;
    List<Product> list =
        docs.map((document) => Product.fromSnapshot(document)).toList();
    //final fav = Favourites.fromSnapshot(doc);
    return list;
  }

  Future<bool> getFavData(
      QuerySnapshot snapshot, AppUser user, String image) async {
    //var snapshot = await model.getFavourites(user);
    bool favstatus = false;
    var docs = await snapshot.documents;

    List list =
        docs.map((document) => Favourites.fromSnapshot(document)).toList();

    map = Map.fromIterable(docs,
        key: (doc) => doc.documentID,
        value: (doc) => Favourites.fromSnapshot(doc));

    list.forEach((document) {
      Favourites fav = document;

      if (image == fav.imageList[0]) {
        favstatus = true;
        //return favstatus;
      }
    });

    return favstatus;
  }

  Future<Map<String, Product>> getAllDocIds() async {
    Map<String, Product> prod_map;
    try {
      var results = await Firestore.instance
          .collection(EnumToString.parse(CollectionTypes.sarees))
          .getDocuments();

      var docs = results.documents;
      prod_map = Map.fromIterable(docs,
          key: (doc) => doc.documentID,
          value: (doc) => Product.fromSnapshot(doc));

      return prod_map;
    } catch (e) {
      return null;
    }
  }

  Future<Map<bool, Map<String, Favourites>>> callFav(
      BuildContext context, String image) async {
    bool favstatus = false;
    AppUser user = Provider.of<AppUser>(context, listen: false);
    final snapshot = await Firestore.instance
        .collection(EnumToString.parse(CollectionTypes.user_favourites))
        .where('id', isEqualTo: '${user.uid}')
        .getDocuments();
    favstatus = await getFavData(snapshot, user, image);

    Map<bool, Map<String, Favourites>> mymap = {favstatus: map};
    return mymap;
  }

  bool get isLoading {
    return _isLoading;
  }

  void setImageFile(File image) {
    _imageFile = image;
    notifyListeners();
  }

  File get imageFile {
    return _imageFile;
  }

  Future<bool> uploadAllProductDataToFirebase(
      List<File> imageFileList,
      String name,
      String description,
      num price,
      num discount,
      num quantity,
      List<String> colors,
      List<String> sizes,
      String category) async {
    //call uploadImage function
    _isLoading = true;
    List<String> imagePathList = [];

    print(imageFile);
    print(name);
    print(_isLoading);

    for (File file in imageFileList) {
      var imageLocation = await uploadImage(file);
      imagePathList.add(imageLocation);
    }

    //var imageLocation = await uploadImage(imageFile);
    var status = await uploadProductToDatabase(
        imagePathList,
        //imageLocation,
        name,
        description,
        price,
        discount,
        category,
        quantity,
        colors,
        sizes);
    _isLoading = false;
    if (status) {
      //_isLoading = false;
      return Future.value(true);
    } else {
      //_isLoading = false;
      return Future.value(false);
    }
  }

  Future<String> uploadImage(File imageFile) async {
    try {
      //make image number random
      int randomNumber = Random().nextInt(100000);
      String imageLocation = '/images/image${randomNumber}.jpg';

      //upload image to firebase
      final StorageReference storageReference =
          FirebaseStorage().ref().child(imageLocation);
      final StorageUploadTask uploadTask = storageReference.putFile(imageFile);
      await uploadTask.onComplete;
      return Future.value(imageLocation);
    } catch (e) {
      print(e.toString());
      return Future.value(null);
    }
  }

  Future<bool> uploadProductToDatabase(
      //var imageLocation,
      List<String> imageLocationList,
      String name,
      String description,
      num price,
      num discount,
      String category,
      num quantity,
      List<String> colors,
      List<String> sizes) async {
    try {
      List<String> ImageLocUrl = [];
      // imageLocation.then((str) async{
      // var ref = await FirebaseStorage().ref().child(imageLocation);
      // var imageString = await ref.getDownloadURL();

      for (String imageLocation in imageLocationList) {
        var ref = await FirebaseStorage().ref().child(imageLocation);
        var imageString = await ref.getDownloadURL();
        ImageLocUrl.add(imageString);
      }

      await Firestore.instance
          .collection(EnumToString.parse(CollectionTypes.sarees))
          .document()
          .setData({
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'discount': discount,
        'quantity': quantity,
        'colors': colors,
        'sizes': sizes,
        'imageurlList': ImageLocUrl,
        'createdAt': FieldValue.serverTimestamp()
      });
      // });

      return Future.value(true);
    } catch (e) {
      print(e.message);

      return Future.value(false);
    }
  }

  void setImages(List<Asset> images) async {
    _images = images;
    await getImage(_images);

    notifyListeners();
  }

  List<Asset> get images {
    return _images;
  }

  // void setImageFiles(List<File> images) {
  //   imageFiles = images;

  //   notifyListeners();
  // }

  Future<List<File>> getImage(List<Asset> images) async {
    //MList<File>ap<int, Asset> map = await model.images.asMap();
    List<File> imageFileLists = [];
    //img = map[0];
    // map.forEach((key, value) async {
    //   String path = await FlutterAbsolutePath.getAbsolutePath(value.identifier);
    //   file = File(path);
    //   imageFiles.add(file);
    // });
    //imageFiles.clear();
    for (Asset asset in images) {
      String path = await FlutterAbsolutePath.getAbsolutePath(asset.identifier);
      File file = File(path);
      imageFileLists.add(file);
    }

    _imageFiles = imageFileLists;
    return imageFileList;
  }

  List<File> get imageFileList {
    return _imageFiles;
  }

  Future<Map<String, Cart>> updateCartCard(AppUser user) async {
    try {
      final snapshot = await Firestore.instance
          .collection(EnumToString.parse(CollectionTypes.user_cart))
          .where('id', isEqualTo: '${user.uid}')
          .getDocuments();
      var docs = await snapshot.documents;
      Map<String, Cart> product = Map.fromIterable(docs,
          key: (doc) => doc.documentID, value: (doc) => Cart.fromSnapshot(doc));
      return product;
    } catch (e) {
      return null;
    }
  }

  void uploadCart(num quantity, String docId) async {
    try {
      await Firestore.instance
          .collection(EnumToString.parse(CollectionTypes.user_cart))
          .document(docId)
          .updateData({'quantity': quantity});
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> getUserCartCount(BuildContext context) async {
    Map<String, Cart> map_cart;
    int count = 0;
    try {
      AppUser user = Provider.of<AppUser>(context);
      final snapshot = await Firestore.instance
          .collection(EnumToString.parse(CollectionTypes.user_cart))
          .where('id', isEqualTo: '${user.uid}')
          .getDocuments();
      var docs = await snapshot.documents;

      map_cart = Map.fromIterable(docs,
          key: (doc) => doc.documentID, value: (doc) => Cart.fromSnapshot(doc));

      map_cart.forEach((key, value) {
        count = count + value.quantity;
      });

      return count;
    } catch (e) {
      print(e.toString());
      return 0;
    }
  }

  void deleteUserCart(String docId) async {
    await Firestore.instance
        .collection(EnumToString.parse(CollectionTypes.user_cart))
        .document(docId)
        .delete();
  }

  Future<int> getFavCount() async {
    // Map<String, Favourites> map_fav;
    var snapshot = await Firestore.instance
        .collection(EnumToString.parse(CollectionTypes.user_favourites))
        .getDocuments();
    var docs = await snapshot.documents;

    List list =
        docs.map((document) => Favourites.fromSnapshot(document)).toList();

    return list.length;

    // map_fav = Map.fromIterable(docs,
    //     key: (doc) => doc.documentID,
    //     value: (doc) => Favourites.fromSnapshot(doc));
  }

  Future<List<Image>> getImageList(List<dynamic> urlList) async {
    List<Image> imgList = [];
    try {
      urlList.forEach((url) async {
        Image img = await Image.network(
          url,
          fit: BoxFit.scaleDown,
        );
        imgList.add(img);
      });
      return Future.value(imgList);
    } catch (e) {
      return null;
    }
  }
}
