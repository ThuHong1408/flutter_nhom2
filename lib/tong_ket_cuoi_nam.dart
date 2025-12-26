import 'package:flutter/material.dart';
import 'package:flutter_nhom2/arctical.dart';
import 'package:flutter_nhom2/change_color_app.dart';
import 'package:flutter_nhom2/counter_app.dart';
import 'package:flutter_nhom2/dang_ky.dart';
import 'package:flutter_nhom2/dang_nhap.dart';
import 'package:flutter_nhom2/home_page.dart';
import 'package:flutter_nhom2/my_product.dart';
import 'package:flutter_nhom2/my_school.dart';
import 'package:flutter_nhom2/my_screen.dart';
import 'package:flutter_nhom2/phan_hoi.dart';
import 'tinh_chi_so_BMI.dart';

class TongKetCuoiNam extends StatelessWidget {
  const TongKetCuoiNam({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TỔNG HỢP BÀI FLUTTER"),
        centerTitle: true,
      ),

      // ================= DRAWER MENU =================
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/menu.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.6),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  child: Center(
                    child: Text(
                      "DANH SÁCH BÀI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                _menuItem(context, "Bài 1", HomePage()),
                _menuItem(context, "Bài 2", const MySchool()),
                _menuItem(context, "Bài 3", MyScreen()),
                _menuItem(context, "Bài 4", DangNhapScreen()),
                _menuItem(context, "Bài 5", DangKy()),
                _menuItem(context, "Bài 6", PhanHoi()),
                _menuItem(context, "Bài 7", TinhBMI()),
                _menuItem(context, "Bài 8", CounterApp()),
                _menuItem(context, "Bài 9", ChangeColorApp()),
                _menuItem(context, "Bài 10", const NewsListScreen()),
                _menuItem(context, "Bài 11", MyProduct()),
              ],
            ),
          ),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/giao_dien.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, Widget page) {
    return ListTile(
      leading: const Icon(Icons.book, color: Colors.white),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }
}
