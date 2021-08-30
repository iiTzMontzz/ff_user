import 'package:maps_toolkit/maps_toolkit.dart';

class MapKitHelper {
  static double getMarkerRotation(sourceLat, sourceLng, destiLat, destiLng) {
    var rotation = SphericalUtil.computeHeading(
        LatLng(sourceLat, sourceLng), LatLng(destiLat, destiLng));
    return rotation;
  }
}
