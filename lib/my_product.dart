import 'package:flutter/material.dart';
import 'package:flutter_nhom2/API.dart';
import 'package:flutter_nhom2/product.dart';
import 'package:flutter_nhom2/product_detail-screen.dart';
import 'package:flutter_nhom2/cart_service.dart';
import 'package:flutter_nhom2/cart_screen.dart';

class MyProduct extends StatefulWidget {
  const MyProduct({super.key});

  @override
  State<MyProduct> createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  late Future<List<Product>> _productsFuture;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _productsFuture = testApi.getAllProduct();

    _productsFuture.then((products) {
      setState(() {
        _allProducts = products;
        _filteredProducts = products;
      });
    });

    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      final searchResults = _allProducts.where((product) {
        return product.title.toLowerCase().contains(query);
      }).toList();

      if (_selectedCategory != null) {
        final filterText = _selectedCategory!.toLowerCase();
        _filteredProducts = searchResults.where((product) {
          return product.category.toLowerCase().contains(filterText);
        }).toList();
      } else {
        _filteredProducts = searchResults;
      }
    });
  }

  // ------------------ QUICK FILTER ------------------
  Widget _buildQuickFilters() {
    const List<String> categories = [
      "SSD",
      "Gold",
      "Gaming",
      "Women",
      "Men",
      "inches",
      "USB",
      "backpack",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: categories.map((category) {
          final isSelected = _selectedCategory == category;
          return ActionChip(
            label: Text(category),
            backgroundColor: isSelected
                ? Colors.blueAccent
                : Colors.grey.shade200,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            onPressed: () {
              setState(() {
                _selectedCategory = isSelected ? null : category;
                _searchController.clear();
                _filterProducts();
              });
            },
          );
        }).toList(),
      ),
    );
  }

  // =================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Sách Sản Phẩm'),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,

        // 🔙 QUAY LẠI
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        // 🏠 HOME + 🛒 GIỎ HÀNG
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),

          // GIỎ HÀNG + BADGE
          AnimatedBuilder(
            animation: cartService,
            builder: (context, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                  ),
                  if (cartService.totalItems > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          cartService.totalItems.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],

        // 🔍 THANH TÌM KIẾM
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm sản phẩm...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 16),
            child: Text(
              'Lọc nhanh:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ),

          _buildQuickFilters(),

          const Divider(height: 10),

          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Lỗi tải dữ liệu: ${snap.error}'));
                }
                return myListView(_filteredProducts);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ LIST VIEW ------------------
  Widget myListView(List<Product> ls) {
    if (ls.isEmpty) {
      return const Center(child: Text('Không có sản phẩm.'));
    }

    return ListView.builder(
      itemCount: ls.length,
      itemBuilder: (context, index) {
        return myItem(ls[index], context);
      },
    );
  }

  Widget myItem(Product p, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(product: p),
              ),
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              p.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            p.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Text(
            '\$${p.price.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
