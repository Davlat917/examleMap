import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_and_flutter_map/controller/yandex_map_controller.dart';
import 'package:yandex_and_flutter_map/pages/flutter_map_page.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapPage extends StatelessWidget {
  const YandexMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    YandexMapControllerr yandexControllerr = Provider.of<YandexMapControllerr>(context);
    // ignore: prefer_const_constructors
    return Scaffold(
      body: yandexControllerr.isLoading
          ? Expanded(
              child: YandexMap(
                onMapTap: (Point point) {
                  yandexControllerr.onLabelTap(point);
                  yandexControllerr.makeRoute( end: point);
                },
                mapObjects: yandexControllerr.mapObjects,
                onMapCreated: yandexControllerr.onMapCreated,
                onObjectTap: (geoObject) {
                  yandexControllerr.myHome;
                },
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Spacer(),
          //? Home
          FloatingActionButton(
            onPressed: () {
              yandexControllerr.myHome;
            },
            backgroundColor: Colors.black12,
            child: const Icon(Icons.home),
          ),
          const Spacer(
            flex: 4,
          ),
          FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            onPressed: () {
              yandexControllerr.mapZoomIn();
            },
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 10,
          ),
           FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            onPressed: () {
              yandexControllerr.goLiveListen();
            },
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            child: const Icon(Icons.location_searching_rounded),
          ),
           const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            onPressed: () {
              yandexControllerr.mapZoomOut();
            },
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            child: const Icon(Icons.remove),
          ),
          const Spacer(
            flex: 2,
          ),
          FloatingActionButton(
            onPressed: () {
              yandexControllerr.meniTop();
            },
            backgroundColor: Colors.indigo.shade100,
            child: const Icon(
              Icons.navigation_rounded,
              color: Colors.indigoAccent,
              size: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FlutterMapPage(),
                ),
              );
            },
            backgroundColor: Colors.indigo.shade300,
            child: const FlutterLogo(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          )
        ],
      ),
    );
  }
}
