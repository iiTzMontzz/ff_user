import 'package:ff_user/models_folder/address.dart';
import 'package:ff_user/screens_folder/_pages/__functions/pet_reciever.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  Address pickupAddress;
  Address destinationAddress;
  PetReciever reciever;

  void updatePickupAddress(Address address) {
    pickupAddress = address;
    notifyListeners();
  }

  void updateDestinationAddress(Address address) {
    destinationAddress = address;
    notifyListeners();
  }

  void updatepetonlyride(PetReciever petReciever) {
    reciever = petReciever;
    notifyListeners();
  }
}