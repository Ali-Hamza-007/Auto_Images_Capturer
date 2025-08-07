import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'home_page.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras =
      await availableCameras(); // ensure this runs before app for Camera to Activate
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(cameras: cameras),
    );
  }
}
