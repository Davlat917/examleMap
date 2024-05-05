
// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class FlutterMapControllerr extends ChangeNotifier {
  FlutterMapControllerr() {
    determinePosition();
  }

  var location = Location();
  var isLoading = false;
  MapController mapController = MapController();
  late LocationData locationData;
  LatLng tap = const LatLng(0, 0);
  double zoomLevel = 12.0;

  Future<LocationData> determinePosition() async {
    isLoading = false;
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.error('Location permissions are denied');
      }
    }

    locationData = await location.getLocation();
    isLoading = true;
    notifyListeners();
    return locationData;
  }

  void findMe() async {
    try {
      locationData = await determinePosition();
      if (locationData != null) {
        mapController.move(
          LatLng(locationData.latitude!, locationData.longitude!),
          zoomLevel,
        );
      }
    } catch (e) {
      debugPrint('Error finding location: $e');
    }
  }

  void zoomIn() {
    if (zoomLevel < 20.0) {
      zoomLevel += 1.0;
      mapController.move(
        mapController.camera.center,
        zoomLevel,
      );
      notifyListeners();
    }
  }

  void zoomOut() {
    if (zoomLevel > 1.0) {
      zoomLevel -= 1.0;
      mapController.move(
        mapController.camera.center,
        zoomLevel,
      );
      notifyListeners();
    }
  }

  void onTap(TapPosition tapPosition, LatLng latLng) {
    tap = latLng;
    notifyListeners();
  }
}