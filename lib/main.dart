import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // ✅ Firebase Core
import 'screens/scanner_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    print("✅ Firebase Initialized");
  } catch (e) {
    print(
      "❌ Firebase Initialization Failed: $e",
    ); // ❌ แจ้งเตือนหากเชื่อมไม่สำเร็จ
  }

  runApp(PlantCareApp());
}

class PlantCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Care',
      theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'Kanit'),
      home: ScannerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
