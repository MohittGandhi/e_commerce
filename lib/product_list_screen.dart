import 'dart:typed_data';  // Required for Uint8List
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart'; // For QR scanning
import 'package:qr_flutter/qr_flutter.dart';  // For QR generation
import 'add_product_screen.dart';
import 'qr_scanner_screen.dart';  // Import the screen for QR scanning

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // List to store products retrieved from Firestore
  List<Map<String, dynamic>> products = [];

  // Function to fetch products from Firestore
  Future<void> _fetchProducts() async {
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    setState(() {
      products = snapshot.docs.map((doc) {
        final data = doc.data()!;
        return {
          'name': data['name'],
          'description': data['description'],
          'price': data['price'],
          'qrCodeId': data['qrCodeId'],
        };
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  // Function to handle product addition
  void _onAddProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddProductScreen()),
    );
    if (result != null) {
      setState(() {
        products.add(result); // Add new product to list
      });
    }
  }

  // Generate QR code using qr_flutter
  Widget generateQRCode(String data) {
    return QrImageView(
      data: data,  // The QR code data
      size: 100.0, // The size of the QR code image
      backgroundColor: Colors.white,  // Background color for QR code
    );
  }

  // Navigate to QR Scanning Screen
  void _scanQRCode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScannerScreen()), // QR scanning screen
    );
    if (result != null) {
      // Handle the scanned QR code result here (e.g., show product details or add to cart)
      print("Scanned QR Code: $result");
    }
  }

  // Function to handle pull-to-refresh
  Future<void> _onRefresh() async {
    await _fetchProducts(); // Refresh the products from Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,  // Trigger the refresh
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Display product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text(product['description']),
                          SizedBox(height: 8),
                          Text('\₹ ${product['price'].toString()}'),
                        ],
                      ),
                    ),
                    // Display QR code
                    Container(
                      height: 100,
                      width: 100,
                      child: generateQRCode(product['qrCodeId']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Floating button for adding a product
          FloatingActionButton(
            onPressed: _onAddProduct,
            child: Icon(Icons.add),
            heroTag: null, // To avoid collision with QR scanner button
          ),
          SizedBox(width: 16),  // Space between the buttons
          // Floating button for scanning QR code
          FloatingActionButton(
            onPressed: _scanQRCode,
            child: Icon(Icons.qr_code),
            heroTag: null, // To avoid collision with Add product button
          ),
        ],
      ),
    );
  }
}
