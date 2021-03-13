//import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shoppingapp2/admin/add_products_admin.dart';
import 'package:shoppingapp2/services/mainservice.dart';

class ImageCapture extends StatefulWidget {
  static const String id = 'ImageCapture';

  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

//enum AppState { free, picked, cropped }

class _ImageCaptureState extends State<ImageCapture> {
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 40.0),
            Center(
              child: Text('Select Images : $_error'),
            ),
            Container(
              width: 200.0,
              height: 50.0,
              margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
              child: RaisedButton(
                  child: Text('Pick Images'), onPressed: loadAssets),
            ),
            SizedBox(height: 40.0),
            Expanded(
              flex: 4,
              child: images.length == 0
                  ? Container(
                      child: Center(child: Text('Choose images')),
                    )
                  : buildGridView(),
            ),
            SizedBox(height: 40.0),
            Expanded(
              flex: 1,
              child: Container(
                  width: 200.0,
                  height: 30.0,
                  margin: EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 30.0),
                  child: ScopedModelDescendant<MainService>(
                    builder: (BuildContext context, Widget child,
                        MainService model) {
                      return RaisedButton(
                          child: Text('get Images'),
                          onPressed: () async {
                            await model.setImages(images);
                            
                            Navigator.pop(context);
                          });
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
     

    });
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 2,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }
}
// File imageFile;
// AppState state;

// Future<Null> _pickImage(ImageSource source) async {
//   // ignore: invalid_use_of_visible_for_testing_member
//   imageFile = (await ImagePicker.platform.pickImage(
//     source: source,
//     maxHeight: 150.0,
//     maxWidth: 150.0)) as File;

//   if (imageFile != null) {
//     setState(() {
//       state = AppState.picked;
//     });
//   }
// }

// Future<Null> _cropImage() async {
//   File croppedFile = await ImageCropper.cropImage(
//     sourcePath: imageFile.path,
//   );

//   if (croppedFile != null) {
//     imageFile = croppedFile;
//     setState(() {
//       state = AppState.cropped;
//     });
//   }
// }

// void _clearImage() {
//   imageFile = null;
//   setState(() {
//     state = AppState.free;
//   });
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     bottomNavigationBar: BottomAppBar(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: <Widget>[
//           IconButton(
//               icon: Icon(Icons.camera),
//               onPressed: () => _pickImage(ImageSource.camera)),
//           IconButton(
//               icon: Icon(Icons.photo_library),
//               onPressed: () => _pickImage(ImageSource.gallery)),
//         ],
//       ),
//     ),
//     body: imageFile != null
//         ? Column(
//             children: <Widget>[
//               imageFile != null ? Image.file(imageFile) : Container(),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   FlatButton(
//                     child: Icon(Icons.crop),
//                     onPressed: () {
//                       _cropImage();
//                     },
//                   ),
//                   FlatButton(
//                       child: Icon(Icons.refresh),
//                       onPressed: () {
//                         _clearImage();
//                       }),
//                   ScopedModelDescendant<MainService>(
//                     builder: (BuildContext context, Widget child,
//                         MainService model) {
//                       return FlatButton(
//                           onPressed: () {
//                             model.setImageFile(imageFile);
//                             Navigator.pop(context);
//                           }, child: Icon(Icons.check));
//                     },
//                   )
//                 ],
//               ),
//             ],
//           )
//         : Container(),
//     );
//   }
//
