import 'package:flutter/material.dart';
import 'package:shoppingapp2/app_consts/app_var.dart';
//import 'package:shoppingapp2/services/mainservice.dart';

class CustomEmailTextField extends StatefulWidget {
  final String text;
  final Function inputfn;
  final FocusScopeNode node;

  CustomEmailTextField({
    this.text, 
    this.inputfn, 
    this.node
    });

  @override
  _CustomEmailTextFieldState createState() => _CustomEmailTextFieldState();
}

class _CustomEmailTextFieldState extends State<CustomEmailTextField> {
  //final FocusScopeNode _node = FocusScopeNode();
  // bool _isToggleVisibility = true;

  @override
  void initState() {
    super.initState();
    //focusNode = FocusNode();
    //focusNode.unfocus();
    //print(focusNode.hasFocus);
  }

  @override
  void dispose() {
    //widget.node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(_node.hasFocus);
    return TextFormField(
        // focusNode: _node,
        textInputAction: TextInputAction.next,
        onEditingComplete: widget.node.nextFocus,
        decoration: InputDecoration(
          labelText: '${widget.text}',
          hoverColor: Colors.blueAccent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Color(mywhite1),
              )),
          labelStyle: TextStyle(
            fontSize: 12,
            color: Color(mywhite1),
          ),
        ),
        cursorColor: Color(mywhite1),
        style: TextStyle(
          color: Color(mywhite1),
          fontFamily: 'Nexa',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.emailAddress,
        //obscureText: widget.text == 'Password' ? _isToggleVisibility : false,
        onSaved: (input) => widget.inputfn(input),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter email id';
          }
          if (!(value.contains('@'))) {
            return 'Invalid Email Id';
          }
        });
  }
}

class CustomPasswordTextField extends StatefulWidget {
  final String text;
  final Function inputfn;
  final Function submitfn;
  final FocusScopeNode node;

  CustomPasswordTextField({
    this.text, 
    this.inputfn, 
    this.submitfn, 
    this.node
    });

  @override
  _CustomPasswordTextFieldState createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  // FocusNode focusNode;
  bool _isToggleVisibility = true;
  //final _controller1 = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // _controller1.dispose();
    //widget.node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(focusNode.hasFocus);
    return TextFormField(
        textInputAction: TextInputAction.done,
        // onEditingComplete:( BuildContext context, MainService mode) => widget.submitfn,
        // onFieldSubmitted: ( BuildContext context, MainService model) => widget.submitfn,
        //controller: _controller1,
        decoration: InputDecoration(
          suffixIcon: widget.text == 'Password'
              ? IconButton(
                  icon: _isToggleVisibility
                      ? Icon(Icons.visibility_off)
                      : Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isToggleVisibility = !_isToggleVisibility;
                    });
                  })
              : null,
          labelText: '${widget.text}',
          hoverColor: Colors.blueAccent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Color(mywhite1),
              )),
          labelStyle:
              // focusNode.hasFocus
              //     ? TextStyle(
              //         color: Colors.blue,
              //       )
              //     :
              TextStyle(
            fontSize: 12,
            color: Color(mywhite1),
          ),
        ),
        cursorColor: Color(mywhite1),
        style: TextStyle(
          color: Color(mywhite1),
          fontFamily: 'Nexa',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.emailAddress,
        obscureText: _isToggleVisibility,
        onSaved: (input) => widget.inputfn(input),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter password';
          }
          if (value.length < 6) {
            return 'Length less than 6 characters';
          }
          // if (!(value.contains('@'))) {
          //   return 'Invalid Email Id';
          // }
        });
  }
}

class CustomUsernameTextField extends StatefulWidget {
  final String text;
  final Function inputfn;
  final FocusScopeNode node;

  CustomUsernameTextField({
    this.text, 
    this.inputfn, 
    this.node
    });

  @override
  _CustomUsernameTextFieldState createState() =>
      _CustomUsernameTextFieldState();
}

class _CustomUsernameTextFieldState extends State<CustomUsernameTextField> {
  //FocusNode focusNode;

  // bool _isToggleVisibility = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
   // widget.node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        //focusNode: focusNode,
        textInputAction: TextInputAction.next,
        onEditingComplete: widget.node.nextFocus,
        decoration: InputDecoration(
          labelText: '${widget.text}',
          hoverColor: Colors.blueAccent,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.blue,
            ),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide(
                color: Color(mywhite1),
              )),
          labelStyle:
              // focusNode.hasFocus
              //     ? TextStyle(
              //         color: Colors.blue,
              //       )
              //     :
              TextStyle(
            fontSize: 12,
            color: Color(mywhite1),
          ),
        ),
        cursorColor: Color(mywhite1),
        style: TextStyle(
          color: Color(mywhite1),
          fontFamily: 'Nexa',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.emailAddress,
        onSaved: (input) => widget.inputfn(input),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a username';
          }
        });
  }
}
