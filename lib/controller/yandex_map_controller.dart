import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

late Position position2;

class YandexMapControllerr extends ChangeNotifier {
  YandexMapControllerr() {
    joylashuvniAniqlash();
    addInitMapObject();
  }
  //! camera zoom variable
  double cameraZoom = 0;
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
  }

  //! joylashuvingizni olamiz
  void meniTop() async {
    BoundingBox boundingBox = BoundingBox(
      northEast:
          Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
      southWest:
          Point(latitude: myPosition.latitude, longitude: myPosition.longitude),
    );
    yandexMapController.moveCamera(
      CameraUpdate.newTiltAzimuthGeometry(
        Geometry.fromBoundingBox(boundingBox),
      ),
    );
    yandexMapController.moveCamera(
      CameraUpdate.zoomTo(20),
    );
    putLabel(myPosition);
  }

//? Camera Zoom get
  void cameraZoomGEt({required double zoom}) async {
    cameraZoom = zoom;
    notifyListeners();
  }

  //? hozirgi joylashuvingizni haritada zoom qilish
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

    notifyListeners();
  }

//? Hariataga mavjud Obyektlarni joylovchi
  void addInitMapObject() {
    mapObjects.addAll([
      addMapObjectMetro(
          latitude: 41.303308, longitude: 69.235699, objectname: 'Milliy bog`'),
      addMapObjectMetro(
          latitude: 41.318843,
          longitude: 69.254252,
          objectname: 'Alisher Navoiy'),
      addMapObjectMetro(
          latitude: 41.332425, longitude: 69.219033, objectname: 'Tinchlik'),
    ]);
    notifyListeners();
  }

//? haritada home iconi qo'yaman
  PlacemarkMapObject addMapObjectIconHome({
    required double latitude,
    required double longitude,
    required String objectname,
  }) {
    return PlacemarkMapObject(
      mapId: MapObjectId(objectname),
      point: Point(latitude: latitude, longitude: longitude),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/icons/home.jpg'),
            scale: 0.2),
      ),
    );
  }

//? haritada metro iconi qo'yaman
  PlacemarkMapObject addMapObjectMetro({
    required double latitude,
    required double longitude,
    required String objectname,
  }) {
    return PlacemarkMapObject(
      mapId: MapObjectId(objectname),
      point: Point(latitude: latitude, longitude: longitude),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          scale: 0.2,
          image: BitmapDescriptor.fromAssetImage('assets/icons/metro.png'),
        ),
      ),
    );
  }

//? zoom in
  void mapZoomIn() {
    yandexMapController.moveCamera(
      CameraUpdate.zoomIn(),
    );
  }

//? zoom out
  void mapZoomOut() {
    yandexMapController.moveCamera(
      CameraUpdate.zoomOut(),
    );
  }

  void onLabelTap(Point point) {
    PlacemarkMapObject addObject = PlacemarkMapObject(
      mapId: MapObjectId(
        point.longitude.toString(),
      ),
      point: point,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/icons/flag.png'),
            scale: 0.2),
      ),
    );
    mapObjects.add(addObject);
    mapObjects.removeRange(2, mapObjects.length - 1);
    notifyListeners();
  }

  //? Seni kuzatuvchi(Icon)
  void putLabel(Position position) {
    PlacemarkMapObject placemarkMapObject = PlacemarkMapObject(
      mapId: const MapObjectId('myLocationId'),
      point: Point(latitude: position.latitude, longitude: position.longitude),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image:
                BitmapDescriptor.fromAssetImage('assets/icons/navigator.png'),
            scale: 0.25),
      ),
    );
    mapObjects.add(placemarkMapObject);
    // mapObjects.removeRange(3, mapObjects.length - 1);
    notifyListeners();
    goLiveListen();
  }

  //? Seni Kuzatish
  Future<void> goLiveListen() async {
    //? kuzatayapti
    Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
                accuracy: LocationAccuracy.best, distanceFilter: 0))
        .listen((live) {
      putLabel(live);
      log('${live.speed}');
      BoundingBox boundingBox = BoundingBox(
        northEast: Point(latitude: live.latitude, longitude: live.longitude),
        southWest: Point(latitude: live.latitude, longitude: live.longitude),
      );
      // yandexMapController.moveCamera(
      //   CameraUpdate.newTiltAzimuthGeometry(
      //     Geometry.fromBoundingBox(boundingBox),
      //   ),
      // );
      // yandexMapController.moveCamera(
      //   CameraUpdate.zoomTo(18),
      // );
    });
    notifyListeners();
  }

  //? Haritadan point Tanlanganda
  Future<void> makeRoad(Position startPoint, Point endPoint) async {
    var resultSession = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
            point: Point(
              latitude: startPoint.latitude,
              longitude: startPoint.longitude,
            ),
            requestPointType: RequestPointType.wayPoint),
        RequestPoint(
            point: endPoint, requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: const DrivingOptions(
        routesCount: 1,
        avoidTolls: true,
        avoidPoorConditions: true,
      ),
    );

    var result = await resultSession.result;

    // Add a Placemark for the end point
    mapObjects.add(
      PlacemarkMapObject(
        mapId: const MapObjectId('endPoint'),
        point: endPoint,
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/icons/home.jpg'),
            scale: 0.3,
          ),
        ),
      ),
    );

    //! Harakat yo'l ko'rinishi
    result.routes?.asMap().forEach((key, value) {
      mapObjects.add(
        PolylineMapObject(
          mapId: MapObjectId("route_$key"),
          polyline: Polyline(points: value.geometry),
          strokeColor: Colors.red,
          strokeWidth: 3,
        ),
      );
    });

    notifyListeners();
  }
}
