import 'package:firebase_database/firebase_database.dart';

class UserData {
  String uid;
  String fullname;
  String email;
  String phone;
  UserData({
    this.uid,
    this.fullname,
    this.email,
    this.phone,
  });

  UserData.fromSnapshot(DataSnapshot snapshot) {
    uid = snapshot.key;
    fullname = snapshot.value['FullName'];
    email = snapshot.value['Email'];
    phone = snapshot.value['phone'];
  }
}
