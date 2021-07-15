import 'package:location/location.dart';

class LocationChecked {
  Future<LocationData> getLocation() async {
    var location = Location();
    await _checkService(location);
    await _checkPermission(location);

    var locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      throw NoLocationException('latitude or longtitude is null!');
    }

    return locationData;
  }

  Future<void> _checkService(Location location) async {
    var serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
  }

  Future<void> _checkPermission(Location location) async {
    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
  }
}

class NoLocationException implements Exception {
  String cause;

  NoLocationException(this.cause);
}
