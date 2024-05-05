import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

late Position position2;

class YandexMapControllerr extends ChangeNotifier {
  YandexMapControllerr() {
    joylashuvniAniqlash();
    myHome;
  }

  //! maskur joylashuvni yuklab olishimiz uchun yaratdik
  late Position myPosition;

  //! joylashuni aniqlab olguncha
  bool isLoading = false;

  //! yandex map Controller
  late YandexMapController yandexMapController;

  //! Xaritadagi joylashuvlar
  List<MapObject> mapObjects = [];

  Future<Position> joylashuvniAniqlash() async {
    isLoading = false;
    bool joylashuv;

    //? navigator tekshirish
    LocationPermission permission;
    joylashuv = await Geolocator.isLocationServiceEnabled();

    //? Ruxsat olinganmi
    if (!joylashuv) {
      return Future.error('Navigator o`chiq');
    }
    //? Ruxsatni tekshirish
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      //? ruxsat so'raladi
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Ruxsat rad etildi');
      }
    }
    //! umrbod rad etilganmi
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Ruxsat umrbod rad etilgan');
    }
    //? nihoyat 😎 joylashuvingizni olamiz
    myPosition = await Geolocator.getCurrentPosition();
    position2 = myPosition;
    isLoading = true;
    notifyListeners();
    return myPosition;
    // ignore: empty_catches
  }

  void meniTop() async {
    BoundingBox boundingBox = BoundingBox(
      northEast: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
      southWest: Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
    );
    yandexMapController.moveCamera(
      CameraUpdate.newTiltAzimuthGeometry(
        Geometry.fromBoundingBox(boundingBox),
      ),
    );
    yandexMapController.moveCamera(
      CameraUpdate.zoomTo(20),
    );
  }

  //? hozirgi joylashuv
  void onMapCreated(YandexMapController controller) async {
    yandexMapController = controller;
    BoundingBox boundingBox = BoundingBox(
      northEast: Point(
        latitude: myPosition.latitude,
        longitude: myPosition.longitude,
      ),
      southWest: Point(
        latitude: myPosition.latitude,
        longitude: myPosition.longitude,
      ),
    );
    yandexMapController.moveCamera(
      CameraUpdate.newTiltAzimuthGeometry(
        Geometry.fromBoundingBox(boundingBox),
      ),
    );
    yandexMapController.moveCamera(
      CameraUpdate.zoomTo(12),
    );
    yandexMapController.moveCamera(
      CameraUpdate.tiltTo(20),
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 4),
    );
    PlacemarkMapObject pdp = addMapOb(latitude: myPosition.latitude, longitude: myPosition.longitude, objectname: 'pdp');
   // mapObjects.add(pdp);
    myHome(controller);
    notifyListeners();
  }

  void myHome(YandexMapController controller) async {
    double latitude = 39.399710;
    double longitude = 67.342124;
    yandexMapController = controller;

    BoundingBox myHome = BoundingBox(
      northEast: Point(latitude: latitude, longitude: longitude),
      southWest: Point(latitude: latitude, longitude: longitude),
    );
    yandexMapController.moveCamera(
      CameraUpdate.newTiltAzimuthGeometry(
        Geometry.fromBoundingBox(myHome),
      ),
    );
    yandexMapController.moveCamera(
      CameraUpdate.zoomTo(12),
    );
    yandexMapController.moveCamera(
      CameraUpdate.tiltTo(20),
      animation: const MapAnimation(type: MapAnimationType.smooth, duration: 4),
    );
    notifyListeners();
    PlacemarkMapObject home = addMapOb(latitude: latitude, longitude: longitude, objectname: 'home');

    //mapObjects.add(home);
    notifyListeners();
  }

  PlacemarkMapObject addMapOb({
    required double latitude,
    required double longitude,
    required String objectname,
  }) {
    return PlacemarkMapObject(
      mapId: MapObjectId(objectname),
      point: Point(latitude: latitude, longitude: longitude),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('assets/icons/home.jpg'), scale: 0.2),
      ),
    );
  }

  void mapZoomIn() {
    yandexMapController.moveCamera(
      CameraUpdate.zoomIn(),
      animation: const MapAnimation(),
    );
  }

  void mapZoomOut() {
    yandexMapController.moveCamera(
      CameraUpdate.zoomOut(),
      animation: const MapAnimation(),
    );
  }

  void onLabelTap(Point point) {
    PlacemarkMapObject addObject = PlacemarkMapObject(
      mapId: MapObjectId(
        point.longitude.toString(),
      ),
      point: point,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('assets/icons/home.jpg'), scale: 0.2),
      ),
    );
   // mapObjects.add(addObject);
    mapObjects.removeRange(2, mapObjects.length - 1);
    notifyListeners();
  }

  void putLabel(Position position) {
    PlacemarkMapObject placemarkMapObject = PlacemarkMapObject(
      mapId: const MapObjectId('myLocationId'),
      point: Point(latitude: position.latitude, longitude: position.longitude),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(image: BitmapDescriptor.fromAssetImage('assets/icons/home.jpg'), scale: 0.2),
      ),
    );
    mapObjects.add(placemarkMapObject);
   // mapObjects.removeRange(3, mapObjects.length - 1);
    notifyListeners();
  }

  Future<void> goLiveListen() async {
    Geolocator.getPositionStream(locationSettings: const LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 0)).listen((live) {
      putLabel(live);
      log('${live.speed}');
      BoundingBox boundingBox = BoundingBox(
        northEast: Point(latitude: live.latitude, longitude: live.longitude),
        southWest: Point(latitude: live.latitude, longitude: live.longitude),
      );
      yandexMapController.moveCamera(CameraUpdate.newTiltAzimuthGeometry(Geometry.fromBoundingBox(boundingBox)));
      yandexMapController.moveCamera(CameraUpdate.zoomTo(18));
    });
    notifyListeners();
  }

  void makeRoute({ required Point end}) {
    final drive = YandexDriving.requestRoutes(
      points: [
        RequestPoint(point: Point(latitude: position2.latitude, longitude: myPosition.latitude), requestPointType: RequestPointType.wayPoint),
        RequestPoint(point: end, requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: const DrivingOptions(
        routesCount: 1,
        avoidTolls: true,
        avoidPoorConditions: true,
      ),
    );
    drive.result.then((value) {
      if (value.routes != null) {
        value.routes?.asMap().forEach((key, value) {
          mapObjects.add(
            PolylineMapObject(
              mapId: MapObjectId('routes$key'),
              strokeColor: Colors.red,
              outlineColor: Colors.green,
              polyline: Polyline(points: value.geometry),
            ),
          );
          notifyListeners();
        });
      }
    });
  }
}
