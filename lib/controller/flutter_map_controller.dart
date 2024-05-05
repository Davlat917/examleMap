import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:yandex_and_flutter_map/controller/yandex_map_controller.dart';

class FlutterMapController extends ChangeNotifier {
  FlutterMapController() {
    criclePolygons;
    addMarker();
    markertlayerslist;
    myfind;
  }
  late MapController mapController;
  // meni joylasuvim
  LatLng menijoylashuvim = LatLng(position2.latitude, position2.longitude);

  int myfind = 0;
  void myfindcount() {
    myfind++;
    debugPrint('$myfind');
    notifyListeners();
  }

  // LatLng myp() {
  //   notifyListeners();
  //   return menijoylashuvim;
  // }

  // void meniqidir() {
  //   mapController.move(menijoylashuvim, 12);
  //   notifyListeners();
  // }

  LatLng joylashuv = const LatLng(39.654904, 66.975571);
  LatLng registon = const LatLng(39.654904, 66.975571);
  List<Widget> addObjects = [];

  void ontap(TapPosition tapPosition, LatLng latLng) {
    registon = latLng;
    MarkerLayer m = mMarkerLayer(latLng: latLng);
    markertlayerslist.add(m);
    notifyListeners();
  }

  void criclePolygons() {
    addObjects.add(
      CircleLayer(
        circles: [
          CircleMarker(
            point: registon,
            radius: 90,
            useRadiusInMeter: true,
            color: Colors.red.withOpacity(0.3),
            borderColor: Colors.red.withOpacity(0.7),
            borderStrokeWidth: 2,
          ),
        ],
      ),
    );
    notifyListeners();
  }

  void textMarker(String text) {
    addObjects.add(
      MarkerLayer(
        markers: [
          Marker(
              point: registon,
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              width: 200,
              height: 80),
        ],
      ),
    );
  }

  List<MarkerLayer> markertlayerslist = [];

  //? joylashuv qo'yish
  MarkerLayer mMarkerLayer({required LatLng latLng}) {
    MarkerLayer markerLayer = MarkerLayer(
      markers: [
        Marker(
          point: latLng,
          child: Image.asset('assets/icons/locationn.png'),
        ),
      ],
    );
    return markerLayer;
  }

  void addMarker() {
    //sam vagzal
    markertlayerslist.add(mMarkerLayer(latLng: const LatLng(39.641124, 66.967397)));
    // sam resta
    markertlayerslist.add(mMarkerLayer(latLng: const LatLng(39.65450, 66.95093)));
    notifyListeners();
  }


}
