import 'package:distances/homepage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Permission.activityRecognition.request();
    await Permission.location.request();
    authorize();
   // fetchStepData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      
      home:HomePage(),
    );
  }
}
