import 'package:flutter/material.dart';
import 'package:shoppingapp2/services/authservice.dart';
import 'package:shoppingapp2/services/searchservice.dart';
import 'package:shoppingapp2/views/homepage_view.dart';

class UploadHistory extends StatefulWidget {
  static String id = 'uploadhistory';

  @override
  _UploadHistoryState createState() => _UploadHistoryState();
}

class _UploadHistoryState extends State<UploadHistory> {
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
            ],
          ),
        ),

        body: Container(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Center(
                    child: Text(
                  'Upload History',
                  style: TextStyle(
                    fontFamily: 'Nexa',
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ))),
            ],
          ) 
        ),
      ),
    );
  }
}
