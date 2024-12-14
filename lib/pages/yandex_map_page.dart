import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_and_flutter_map/controller/yandex_map_controller.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class YandexMapPage extends StatelessWidget {
  const YandexMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    YandexMapControllerr yandexControllerr =
        Provider.of<YandexMapControllerr>(context);

    return Scaffold(
      body: yandexControllerr.isLoading
          ? YandexMap(
              onMapTap: (Point point) {
                yandexControllerr.makeRoad(
                    yandexControllerr.myPosition,
                    Point(
                        latitude: point.latitude, longitude: point.longitude));
              },
              mapObjects: yandexControllerr.mapObjects,
              onMapCreated: yandexControllerr.onMapCreated,
              onObjectTap: (geoObject) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Obyekt Tafsiloti'),
                      content: Text(
                          'Siz ${geoObject.name ?? "nomi yo'q obyekt"} ni bosdingiz!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Yopish'),
                        )
                      ],
                    );
                  },
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        children: [
          const Spacer(),
          FloatingActionButton(
            onPressed: () {
              yandexControllerr.myHome;
            },
            backgroundColor: Colors.black12,
            child: const Icon(Icons.home),
          ),
          const Spacer(flex: 4),
          FloatingActionButton(
            onPressed: yandexControllerr.mapZoomIn,
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          // FloatingActionButton(
          //   onPressed: yandexControllerr.goLiveListen,
          //   backgroundColor: Colors.redAccent.withOpacity(0.6),
          //   child: const Icon(Icons.live_tv_sharp),
          // ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: yandexControllerr.mapZoomOut,
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            child: const Icon(Icons.remove),
          ),
          const Spacer(flex: 2),
          FloatingActionButton(
            onPressed: yandexControllerr.meniTop,
            backgroundColor: Colors.indigo.shade100,
            child: const Icon(
              Icons.navigation_rounded,
              color: Colors.indigoAccent,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
