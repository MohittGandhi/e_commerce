import 'package:flutter/material.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController qrController) {
    controller = qrController;
    controller?.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;
      setState(() {
        result = scanData;
        isProcessing = true;
      });

      try {
        if (result != null) {
          final productSnapshot = await FirebaseFirestore.instance
              .collection('products')
              .where('qrCodeId', isEqualTo: result!.code)
              .get();

          if (productSnapshot.docs.isNotEmpty) {
            final product = productSnapshot.docs.first.data();

            // Add the product to the 'cart' collection
            await FirebaseFirestore.instance.collection('cart').add({
              'name': product['name'],
              'description': product['description'],
              'price': product['price'],
              'qrCodeId': product['qrCodeId'],
            });

            // Show a snack bar confirming the product has been added
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added ${product['name']} to cart')),
            );

            // Navigate to CartPage to show the product details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(productId: productSnapshot.docs.first.id),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Product not found')),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      } finally {
        setState(() {
          isProcessing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Scanned: ${result!.code}')
                  : const Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }
}

class CartPage extends StatelessWidget {
  final String productId;

  CartPage({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('products').doc(productId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Product not found'));
          }

          final product = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: ${product['name']}', style: Theme.of(context).textTheme.headlineSmall),
                SizedBox(height: 8),
                Text('Description: ${product['description']}'),
                SizedBox(height: 8),
                Text('Price: \$${product['price']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

