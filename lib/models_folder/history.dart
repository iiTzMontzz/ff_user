import 'package:firebase_database/firebase_database.dart';

class History {
  String key;
  String pickup;
  String destination;
  String fares;
  String status;
  String createdAt;
  String paymentMethod;

  History({
    this.key,
    this.pickup,
    this.destination,
    this.fares,
    this.status,
    this.createdAt,
    this.paymentMethod,
  });

  History.fromSnapshot(DataSnapshot snapshot) {
    key = snapshot.key;
    pickup = snapshot.value['pickup_address'];
    destination = snapshot.value['destination_address'];
    fares = snapshot.value['fare'].toString();
    createdAt = snapshot.value['date_created'];
    status = snapshot.value['status'];
    paymentMethod = snapshot.value['payment_method'];
  }
}
