import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  String uid;
  String username;

  DocumentReference refernce;

  AppUser({this.uid, this.username});

  AppUser.fromMap(Map<String, dynamic> map, {this.refernce})
      : uid = map['uid'],
        username = map['username'];

  AppUser.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, refernce: snapshot.reference);
}
