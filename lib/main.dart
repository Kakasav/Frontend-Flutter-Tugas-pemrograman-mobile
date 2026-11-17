import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'views/umkm_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Direktori UMKM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D9488),
          primary: const Color(0xFF0284C7),
          secondary: const Color(0xFF0D9488),
        ),
        useMaterial3: true,
      ),
      home: UmkmView(),
    );
  }
}
