import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhanHoi extends StatefulWidget {
  const PhanHoi({super.key});

  @override
  State<PhanHoi> createState() => _PhanHoiState();
}

class _PhanHoiState extends State<PhanHoi> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _contentController = TextEditingController();
  final _fileController = TextEditingController();

  int _selectedRating = 4;
  File? _selectedImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _fileController.text = pickedFile.name;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contentController.dispose();
    _fileController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã gửi phản hồi!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "Gửi phản hồi",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Họ tên
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Họ tên",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Vui lòng nhập họ tên";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              /// Đánh giá
              DropdownButtonFormField<int>(
                decoration: const InputDecoration(
                  labelText: "Đánh giá (1 - 5 sao)",
                  border: OutlineInputBorder(),
                ),
                value: _selectedRating,
                items: [1, 2, 3, 4, 5].map((value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text("$value sao"),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedRating = value!),
              ),

              const SizedBox(height: 15),

              /// Nội dung
              TextFormField(
                controller: _contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Nội dung góp ý",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Vui lòng nhập nội dung góp ý";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              /// Upload ảnh
              TextFormField(
                controller: _fileController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Ảnh đính kèm",
                  hintText: "Chưa có ảnh",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.upload_file),
                    onPressed: _pickImage,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Vui lòng chọn ảnh";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 10),

              if (_selectedImage != null)
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              /// Nút gửi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: _submitForm,
                  child: const Text(
                    "Gửi phản hồi",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
