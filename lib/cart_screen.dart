import 'package:flutter/material.dart';
import 'package:flutter_nhom2/cart_service.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ Hàng Của Bạn'),
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

      body: AnimatedBuilder(
        animation: cartService,
        builder: (context, child) {
          final cartItems = cartService.items;

          // GIỎ HÀNG TRỐNG
          if (cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Giỏ hàng trống. Mời bạn thêm sản phẩm!',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              // DANH SÁCH SẢN PHẨM
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return buildCartItem(context, item);
                  },
                ),
              ),

              // TỔNG TIỀN + THANH TOÁN
              buildCartSummary(context),
            ],
          );
        },
      ),
    );
  }

  // ------------------ ITEM TRONG GIỎ ------------------
  Widget buildCartItem(BuildContext context, CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 2,
      child: ListTile(
        leading: Image.network(
          item.product.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported);
          },
        ),

        title: Text(
          item.product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Giá: \$${item.product.price.toStringAsFixed(2)}'),
            Text(
              'Tổng: \$${item.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                item.quantity > 1 ? Icons.remove : Icons.delete,
                color: item.quantity > 1 ? Colors.blue : Colors.red,
              ),
              onPressed: () {
                cartService.updateQuantity(item.product.id, item.quantity - 1);
              },
            ),

            Text(
              item.quantity.toString(),
              style: const TextStyle(fontSize: 16),
            ),

            IconButton(
              icon: const Icon(Icons.add, color: Colors.blue),
              onPressed: () {
                cartService.updateQuantity(item.product.id, item.quantity + 1);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ TỔNG TIỀN + THANH TOÁN ------------------
  Widget buildCartSummary(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),

      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              Text(
                '\$${cartService.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Chức năng Thanh toán đang được phát triển!'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              'TIẾN HÀNH THANH TOÁN',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
