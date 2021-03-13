import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/admin/add_products_admin.dart';
import 'package:shoppingapp2/admin/image_capture.dart';
import 'package:shoppingapp2/admin/upload_history.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/mainservice.dart';
//import 'package:shoppingapp2/services/mainservice.dart';
import 'package:shoppingapp2/views/Product_view.dart';
import 'package:shoppingapp2/views/authentication_view.dart';
import 'package:shoppingapp2/views/cart.dart';
import 'package:shoppingapp2/views/favourites.dart';
import 'package:shoppingapp2/views/homepage_view.dart';
import 'package:shoppingapp2/views/product_pic_closeup.dart';
import 'package:shoppingapp2/widgets/wrapper.dart';
//import 'package:shoppingapp2/views/homepage_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final MainService mainService = MainService();

    return ScopedModel<MainService>(
      model: mainService,
      child: StreamProvider.value(
        value: AuthService().user,
        child: MaterialApp(
          initialRoute: Wrapper.id,
          routes: {
            AuthenticationView.id: (context) => AuthenticationView(),
            HomePage.id: (context) => HomePage(),
            ProductDisplayPage.id: (context) => ProductDisplayPage(),
            ShoppingCart.id: (context) => ShoppingCart(),
            ProductCloseUp.id: (context) => ProductCloseUp(),
            Wrapper.id: (context) => Wrapper(),
            FavouritesView.id : (context) => FavouritesView(),
            AddProduct.id : (context) => AddProduct(),
            ImageCapture.id : (context) => ImageCapture(),
            UploadHistory.id : (context) => UploadHistory(),
          },
        ),
      ),
    );
  }
}
