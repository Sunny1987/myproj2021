import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/models/appuser.dart';
//import 'package:shoppingapp2/services/mainservice.dart';
import 'package:shoppingapp2/views/authentication_view.dart';
import 'package:shoppingapp2/views/homepage_view.dart';

class Wrapper extends StatelessWidget {
  static String id = 'wrapper';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    return user == null ? AuthenticationView() : HomePage();

    //child: HomePage());
  }
}
