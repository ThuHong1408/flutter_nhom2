import 'package:flutter/material.dart';
import 'tong_ket_cuoi_nam.dart';

void main() {
  runApp(const ThuHongApp());
}

class ThuHongApp extends StatelessWidget {
  const ThuHongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tổng kết Flutter – Thu Hồng',
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const TongKetCuoiNam(),
    );
  }
}
