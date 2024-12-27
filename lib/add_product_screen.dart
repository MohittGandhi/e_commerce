/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qrCodeIdController = TextEditingController();

  void addProduct(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance.collection('products').add({
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'qrCodeId': qrCodeIdController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product Added Successfully')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Enter product name' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter product description' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter product price' : null,
              ),
              TextFormField(
                controller: qrCodeIdController,
                decoration: InputDecoration(labelText: 'QR Code ID'),
                validator: (value) => value!.isEmpty ? 'Enter QR Code ID' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => addProduct(context),
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController qrCodeIdController = TextEditingController();

  // Function to add product to Firestore and navigate back with data
  void addProduct(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final String qrCodeId = Uuid().v4(); // Generate unique QR Code ID

      // Add product to Firebase Firestore
      await FirebaseFirestore.instance.collection('products').add({
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'qrCodeId': qrCodeId,
      });

      // Return to product list screen with product details
      Navigator.pop(context, {
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'qrCodeId': qrCodeId,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) => value!.isEmpty ? 'Enter product name' : null,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter product description' : null,
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter product price' : null,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => addProduct(context),
                child: Text('Add Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

