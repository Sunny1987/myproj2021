import 'package:flutter/material.dart';
//import 'package:shoppingapp2/app_consts/app_var.dart';

class CategoryCard extends StatelessWidget {
  final String image;
  final String productname;
  CategoryCard({this.image,this.productname});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(40),
          ),
      child: Container(
        width: 200,
        //height: 300,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 3.0), blurRadius: 3.0, color: Colors.grey)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0),bottomRight: Radius.circular(20.0)),
              ),
              height: 40,
              
              //width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: Text('$productname',style: TextStyle(
                    fontFamily: 'Nexa',
                    fontWeight: FontWeight.bold
                  ),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
