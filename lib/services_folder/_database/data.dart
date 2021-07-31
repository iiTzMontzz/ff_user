import 'package:cloud_firestore/cloud_firestore.dart';
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
}
