// lib/product_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_nhom2/product.dart';
import 'package:flutter_nhom2/cart_service.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi Tiết Sản Phẩm'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,

        // 🔙 NÚT QUAY LẠI
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        // 🏠 NÚT HOME
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ẢNH SẢN PHẨM
            Center(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 300),
                padding: const EdgeInsets.only(bottom: 20),
                child: Image.network(
                  product.image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.image_not_supported,
                      size: 100,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),

            // GIÁ
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.redAccent,
              ),
            ),

            const SizedBox(height: 10),

            // TÊN SẢN PHẨM
            Text(
              product.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const Divider(height: 30),

            // NÚT THÊM VÀO GIỎ
            AnimatedBuilder(
              animation: cartService,
              builder: (context, child) {
                final isInCart = cartService.isInCart(product);

                return ElevatedButton.icon(
                  icon: Icon(isInCart ? Icons.check : Icons.shopping_cart),
                  label: Text(
                    isInCart ? 'ĐÃ CÓ TRONG GIỎ HÀNG' : 'THÊM VÀO GIỎ HÀNG',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isInCart ? Colors.green : Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: isInCart
                      ? null
                      : () {
                          cartService.addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã thêm sản phẩm vào giỏ hàng!'),
                            ),
                          );
                        },
                );
              },
            ),

            const SizedBox(height: 20),

            // MÔ TẢ
            const Text(
              'Mô tả chi tiết:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 20),

            // THỂ LOẠI
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                'Thể loại: ${product.category}',
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
