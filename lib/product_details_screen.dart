import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String name;
  final String description;
  final double price;
  final String qrCodeId;

  ProductDetailsScreen({
    required this.name,
    required this.description,
    required this.price,
    required this.qrCodeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Description: $description', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Price: \₹${price.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),
            Text('QR Code ID:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                qrCodeId,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

