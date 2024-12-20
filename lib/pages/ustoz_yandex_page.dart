
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yandex_and_flutter_map/pages/yandex_map_page.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';

class CustomYandexMap extends StatefulWidget {
  const CustomYandexMap({super.key});

  @override
  State<CustomYandexMap> createState() => _CustomYandexMapState();
}

class _CustomYandexMapState extends State<CustomYandexMap> {
  late Position myPosition;
  bool isLoading = false;
  late YandexMapController yandexMapController;
  List<MapObject> mapObjects = [];
  double speed = 0;


  Future<Position> _determinePosition() async {
    isLoading = false;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    myPosition = await Geolocator.getCurrentPosition();
    isLoading = true;
    setState(() {});
    return myPosition;
  }

  void onMapCreated(YandexMapController controller){
    yandexMapController = controller;
    BoundingBox boundingBox = const BoundingBox(
      northEast: Point(
          latitude: 41.316830,
          longitude: 69.255045,),
      southWest: Point(
        latitude: 41.316830,
        longitude: 69.255045,),
    );

    controller.moveCamera(
      CameraUpdate.newTiltAzimuthGeometry(
        Geometry.fromBoundingBox(boundingBox),
      ),
    );
    controller.moveCamera(
      CameraUpdate.zoomTo(12),
    );
  }

  void findMe(){
    BoundingBox boundingBox = BoundingBox(
      northEast: Point(
          latitude: myPosition.latitude,
          longitude: myPosition.longitude),
      southWest: Point(
          latitude: myPosition.latitude,
          longitude: myPosition.longitude),
    );

    yandexMapController.moveCamera(
      CameraUpdate.newTiltAzimuthGeometry(
        Geometry.fromBoundingBox(boundingBox),
      ),
    );
    yandexMapController.moveCamera(
      CameraUpdate.zoomTo(18),
    );
    // yandexMapController.moveCamera(
    //   CameraUpdate.tiltTo(50),
    //   animation: const MapAnimation(
    //     type: MapAnimationType.smooth,
    //     duration: 2,
    //   ),
    // );
    putLabel(myPosition);
  }
  
  void putLabel(Position position){
    PlacemarkMapObject placemarkMapObject = PlacemarkMapObject(
        mapId: const MapObjectId("myLocation"), 
      point: Point(
        latitude: position.latitude,
        longitude: position.longitude,
      ),
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage("assets/images/img.png"),
          scale: 0.4,
        )
      )
    );
    log("message");
    
    mapObjects.add(placemarkMapObject);
    setState(() {});
  }

  void putLabelOnTap(Point point){
    PlacemarkMapObject placemarkMapObject = PlacemarkMapObject(
        mapId: MapObjectId(point.longitude.toString()),
        point: point,
        opacity: 1,
        icon: PlacemarkIcon.single(
            PlacemarkIconStyle(
              image: BitmapDescriptor.fromAssetImage("assets/images/img.png"),
              scale: 0.4,
            )
        )
    );
    log("message");
    mapObjects.add(placemarkMapObject);
    mapObjects.removeRange(1, mapObjects.length-1);
    setState(() {});
  }

  Future<void> makeRoad(Position startPoint, Point endPoint)async{
    // var resultSession = YandexBicycle.requestRoutes(
    //     points: [
    //       RequestPoint(
    //           point: Point(
    //             latitude: startPoint.latitude,
    //             longitude: startPoint.longitude,
    //           ),
    //           requestPointType: RequestPointType.wayPoint
    //       ),
    //
    //       RequestPoint(
    //           point: endPoint,
    //           requestPointType: RequestPointType.wayPoint
    //       ),
    //     ],
    //      bicycleVehicleType: BicycleVehicleType.bicycle,
    // );
    var resultSession = YandexDriving.requestRoutes(
      points: [
        RequestPoint(
            point: Point(
              latitude: startPoint.latitude,
              longitude: startPoint.longitude,
            ),
            requestPointType: RequestPointType.wayPoint
        ),

        RequestPoint(
            point: endPoint,
            requestPointType: RequestPointType.wayPoint
        ),
      ],
      drivingOptions: const DrivingOptions(
        routesCount: 1,
        avoidTolls: false,
        avoidPoorConditions: false,
      ),
    );
    var result = await resultSession.result;
    result.routes?.asMap().forEach((key, value) {
      mapObjects.add(PolylineMapObject(
          mapId: MapObjectId("route_$key"),
          polyline: Polyline(points: value.geometry),
        strokeColor: Colors.red,
        strokeWidth: 3,
      ),
      );
    });
    setState(() {});
  }


  Future<void> goLive()async{
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      )
    ).listen((position) {
      putLabel(position);
      speed = position.speed;
      setState(() {});
      log(position.speed.toString());
      log(position.latitude.toString());
      log(position.longitude.toString());
    });
  }

  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const YandexMapPage()));
        }, icon: const Icon(Icons.map_outlined))
      ],),
      body: isLoading
          ? Stack(
        alignment: const Alignment(0, -0.9),
            children: [
              YandexMap(
                      // tiltGesturesEnabled: false,
                  // nightModeEnabled: true,
                  // mode2DEnabled: false,
                  // scrollGesturesEnabled: false,
                  // zoomGesturesEnabled: false,
                  // rotateGesturesEnabled: false,
                      mapObjects: mapObjects,
                  onMapTap: (endPoint){
                    putLabelOnTap(endPoint);
                    makeRoad(myPosition, endPoint);
                  },
                  onMapCreated: onMapCreated,
                ),
              Container(
                height: 40,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 100),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                  ),
                  child: Text("Speed: ${speed.toStringAsFixed(2)} m/s", style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),)),
            ],
          )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: ()async{
      await goLive();
    },
            child: const Icon(Icons.telegram),
          ),
          const SizedBox(height: 30,),
          FloatingActionButton(
            onPressed: () => yandexMapController.moveCamera(
              CameraUpdate.zoomIn()
            ),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 30,),
          FloatingActionButton(
            onPressed: () => findMe(),
            child: const Icon(Icons.location_on),
          ),
          const SizedBox(height: 30,),
          FloatingActionButton(
            onPressed: () => yandexMapController.moveCamera(
                CameraUpdate.zoomOut()
            ),
            child: const Icon(CupertinoIcons.minus),
          ),
        ],
      ),
    );
  }
}