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
          ?YandexMap(
  mapObjects: yandexControllerr.mapObjects,
  onMapCreated: yandexControllerr.onMapCreated,
onObjectTap: (geoObject) {
  try {
    // geoObject.id orqali bosilgan obyektni aniqlaymiz
    final tappedObject = yandexControllerr.mapObjects.firstWhere(
      (object) => object.mapId.value == geoObject.name,
    );

    // Agar obyekt topilsa, dialogni ko'rsatamiz
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Obyekt haqida maʼlumot'),
          content: Text(
            'Siz obyektni bosdingiz: \n'
            'Nomi: ${geoObject.name ?? "Nomaʼlum"}\n'
            'Koordinatalar: Latitude: ${geoObject.geometry.first.point!.latitude}, '
            'Longitude: ${geoObject.geometry.first.point!.longitude}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Yopish'),
            ),
          ],
        );
      },
    );
  } catch (e) {
    // Agar obyekt topilmasa yoki xato yuz bersa
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xato'),
          content: const Text('Bosilgan obyekt haqida maʼlumot topilmadi.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Yopish'),
            ),
          ],
        );
      },
    );
  }
}

)

          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        children: [
          const Spacer(),
          const Spacer(flex: 4),
          FloatingActionButton(
            onPressed: yandexControllerr.mapZoomIn,
            backgroundColor: Colors.redAccent.withOpacity(0.6),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
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
