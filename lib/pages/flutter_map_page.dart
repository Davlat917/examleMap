import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:yandex_and_flutter_map/controller/flutter_map_controller.dart';

class FlutterMapPage extends StatelessWidget {
  const FlutterMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterMapController controller = Provider.of<FlutterMapController>(context);
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          initialCenter: controller.myfind>0? controller.menijoylashuvim:controller.registon,
          initialZoom: 18,
          onTap: controller.ontap,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            rotate: true,
            markers: [
              Marker(
                point: controller.menijoylashuvim,
                child: Image.asset('assets/icons/locationn.png'),
              ),
            ],
          ),
          MarkerLayer(
            rotate: true,
            markers: [
              Marker(
                point: controller.menijoylashuvim,
                child: Image.asset('assets/icons/locationn.png'),
              ),
            ],
          ),
          ...controller.addObjects,
          ...controller.markertlayerslist,
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                controller.criclePolygons();
              },
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed:controller.myfindcount,
              child: const Icon(Icons.navigation_rounded),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
