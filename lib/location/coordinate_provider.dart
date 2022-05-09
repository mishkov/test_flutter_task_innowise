import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class CoordinateProvider {
  final _coordinateStreamController = StreamController<Coordinate>.broadcast();
  Coordinate? _lastCoordinate;
  final _location = Location();

  static final instance = CoordinateProvider._internal();

  factory CoordinateProvider() => instance;

  CoordinateProvider._internal() {
    try {
      _LocationServiceChecker(_location).check();
      _LocationPermissionChecker(_location).check();
    } catch (e) {
      _coordinateStreamController.addError(e);
    }
  }

  Stream<Coordinate> get stream => _coordinateStreamController.stream;

  Coordinate? get lastCoordinate => _lastCoordinate;

  Future<void> fetch() async {
    final timeoutTime = Duration(seconds: 15);

    try {
      final locationData = await _location.getLocation().timeout(
        timeoutTime,
        onTimeout: () {
          _coordinateStreamController
              .addError(LocationGettingTimeoutException());
          throw LocationGettingTimeoutException();
        },
      );
      _lastCoordinate = Coordinate(
        locationData.latitude ?? 0,
        locationData.longitude ?? 0,
      );

      _coordinateStreamController.add(_lastCoordinate!);
    } catch (e) {
      _coordinateStreamController.addError(e);
    }
  }

  Future<void> dispose() async {
    await _coordinateStreamController.close();
  }
}

class Coordinate {
  final double latitude;
  final double longitude;

  Coordinate(this.latitude, this.longitude);
}

class LocationGettingTimeoutException implements Exception {}

class _LocationServiceChecker {
  final Location location;

  _LocationServiceChecker(this.location);

  Future<void> check() async {
    // TODO: Review this piece of code
    //
    // I don't now why but when I call location.serviceEnabled() first time
    // code crashes. And after pressing "Try again" it works fine. But with code
    // below it works fine always
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw LocationServiceIsDisabled();
      }
    }
  }
}

class LocationServiceIsDisabled implements Exception {}

class _LocationPermissionChecker {
  final Location location;

  _LocationPermissionChecker(this.location);

  Future<void> check() async {
    var permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus == PermissionStatus.denied) {
        throw PermissionDeniedException();
      } else if (permissionStatus == PermissionStatus.deniedForever) {
        throw LocationPermissionDeniedForeverException(
            'User has denied location permission forever');
      }
    }
  }
}

class PermissionDeniedException implements Exception {}

class LocationPermissionDeniedForeverException implements Exception {
  String message;

  LocationPermissionDeniedForeverException(this.message);
}
