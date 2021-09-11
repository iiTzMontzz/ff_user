import 'package:ff_user/models_folder/address.dart';
import 'package:ff_user/models_folder/history.dart';
import 'package:ff_user/models_folder/reciever_information.dart';
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  Address pickupAddress;
  Address destinationAddress;
  PetReciever reciever;
  int tripCount = 0;
  List<String> tripHistoryKeys = [];
  List<History> tripHistory = [];

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

  void updateTripCount(int newTripCount) {
    tripCount = newTripCount;
    notifyListeners();
  }

  void updateTripKeys(List<String> newKeys) {
    tripHistoryKeys = newKeys;
    notifyListeners();
  }

  void updateTripHistory(History historyItem) {
    tripHistory.add(historyItem);
    notifyListeners();
  }
}
