import 'package:flutter/material.dart';
import 'profile_screen.dart';

class DangNhapScreen extends StatefulWidget {
  const DangNhapScreen({super.key});

  @override
  State<DangNhapScreen> createState() => _DangNhapScreenState();
}

class _DangNhapScreenState extends State<DangNhapScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tenController = TextEditingController();
  final _matkhauController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _tenController.dispose();
    _matkhauController.dispose();
    super.dispose();
  }

  Future<void> _xuLyDangNhap() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    const String tenDung = 'emlily';
    const String matKhauDung = 'emilypass';

    if (_tenController.text == tenDung &&
        _matkhauController.text == matKhauDung) {
      const String accessToken = 'mocked_jwt_token_as_access_1234567890_abcdef';

      final Map<String, dynamic> userProfile = {
        'id': 1,
        'ho_ten': 'Emily Johnson',
        'ten_thoi_con_gai': 'Smith',
        'tuoi': 29,
        'username': _tenController.text,
        'email': 'emily.johnson@x.dummyjson.com',
        'nhom_mau': 'O-',
        'chieu_cao': 193.24,
        'can_nang': 63.16,
        'mau_mat': 'Green',
        'mau_toc': 'Brown',
        'kieu_toc': 'Curly',
        'dia_chi_thuong_tru': '626 Main Street, Phoenix, Mississippi, US',
        'ten_cong_ty': 'Dooley, Kozey and Cronin',
        'phong_ban': 'Engineering',
        'chuc_danh': 'Sales Manager',
        'vai_tro': 'admin',
      };

      // Chuyển sang Profile (xóa màn hình login)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              ProfileScreen(accessToken: accessToken, userProfile: userProfile),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tên người dùng hoặc mật khẩu không đúng'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Form Đăng nhập"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,

        //==NÚT QUAY LẠI =====
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Chào mừng, vui lòng đăng nhập',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  controller: _tenController,
                  decoration: const InputDecoration(
                    labelText: 'Tên người dùng',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Tên người dùng không được để trống'
                      : null,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _matkhauController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mật khẩu',
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mật khẩu không được để trống';
                    }
                    if (value.length < 6) {
                      return 'Mật khẩu ít nhất 6 ký tự';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // ===== NÚT ĐĂNG NHẬP =====
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _xuLyDangNhap,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    _isLoading ? 'Đang xử lý...' : 'Đăng nhập',
                    style: const TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ===== NÚT QUAY LẠI (PHỤ) =====
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
