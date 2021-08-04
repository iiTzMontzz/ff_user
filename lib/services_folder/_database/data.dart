import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ff_user/models_folder/passenger.dart';
import 'package:ff_user/models_folder/person.dart';

class Data {
  final String uid;
  Data({this.uid});
  final _db = Firestore.instance;

  //Add Pesron
  Future addPerson(String type, String availability) async {
    return await _db
        .collection('Persons')
        .document(uid)
        .setData({'uid': uid, 'Type': type, 'Availability': availability});
  }

//DocumentSnapshot person
  Person _person(DocumentSnapshot snapshot) {
    return Person(
        uid: uid,
        type: snapshot.data['Type'],
        availability: snapshot.data['Availability']);
  }

  //Stream Person
  Stream<Person> get persons {
    return _db.collection('Persons').document(uid).snapshots().map(_person);
  }

  //Add new User
  Future addPassenger(
      String email, String fullname, String phoneNumber, String status) async {
    return await _db.collection('Passenger').document(uid).setData({
      'uid': uid,
      'Email': email,
      'Fullname': fullname,
      'Status': status,
      'Phonenumber': phoneNumber,
    });
  }

  //Datasnpshot of the User
  Passenger _passenger(DocumentSnapshot snapshot) {
    return Passenger(
        uid: uid,
        email: snapshot.data['Email'],
        fullname: snapshot.data['Fullname'],
        status: snapshot.data['Status'],
        phonenumber: snapshot.data['Phonenumber']);
  }

  //Stream User
  Stream<Passenger> get passengerData {
    return _db
        .collection('Passenger')
        .document(uid)
        .snapshots()
        .map(_passenger);
  }
}
