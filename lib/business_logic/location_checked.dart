import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class LocationChecked {
  Future<LocationData> getLocation() async {
    var location = Location();
    await _checkService(location);
    await _checkPermission(location);

    var locationData = await location.getLocation().timeout(Duration(seconds: 15));

    return locationData;
  }

  Future<void> _checkService(Location location) async {
    // I don't now why but when I call location.serviceEnabled() first time
    // code crashes. And after pressing "Try again" it works fine. But with code
    // below it works fine always
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw NoLocationException('Service is not Enabled!');
      }
    }
  }

  Future<void> _checkPermission(Location location) async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) {
        throw NoLocationException('No permission granted!');
      } else if (permissionStatus == PermissionStatus.deniedForever) {
        throw LocationPermissionDeniedForeverException('User has denied location permission forever');
      }
    }
  }
}

class NoLocationException implements Exception {
  String cause;

  NoLocationException(this.cause);
}

class LocationPermissionDeniedForeverException implements Exception {
  String message;

  LocationPermissionDeniedForeverException(this.message);
}
