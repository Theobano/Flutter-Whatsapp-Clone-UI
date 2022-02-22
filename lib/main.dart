import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_whatsapp/screens/home_tabs/camera_tab.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.camera}) : super(key: key);
  final camera;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {"/camera_screen": (context) => CameraScreen(camera: camera)},
      debugShowCheckedModeBanner: false,
      title: 'WhatsApp clone',
      theme: ThemeData(
        primaryColor: Colors.teal[500],
        primarySwatch: Colors.green,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.teal[500],
        ),
      ),
      home: HomeScreen(camera: camera),
    );
  }
}
