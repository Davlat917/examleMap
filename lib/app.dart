import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yandex_and_flutter_map/controller/flutter_map_controller.dart';
import 'package:yandex_and_flutter_map/controller/yandex_map_controller.dart';
import 'package:yandex_and_flutter_map/pages/ustoz_yandex_page.dart';
import 'package:yandex_and_flutter_map/pages/yandex_map_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => YandexMapControllerr()),
        ChangeNotifierProvider(create: (context) => FlutterMapController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: false),
        home: const CustomYandexMap(),
      ),
    );
  }
}
