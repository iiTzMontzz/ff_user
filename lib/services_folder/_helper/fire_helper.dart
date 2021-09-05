import 'package:ff_user/models_folder/nearby_drivers.dart';

class FireHelper {
  static List<NearbyDriver> nearbyDriverlist = [];

  static void removeFromlist(String key) {
    int index = nearbyDriverlist.indexWhere((element) => element.key == key);
    nearbyDriverlist.removeAt(index);
    print("Driver Removed >>>>> $index");
  }

  static void updateNearbyLocation(NearbyDriver nearbyDriver) {
    int index = nearbyDriverlist
        .indexWhere((element) => element.key == nearbyDriver.key);
    nearbyDriverlist[index].lat = nearbyDriver.lat;
    nearbyDriverlist[index].lng = nearbyDriver.lng;
  }
}
