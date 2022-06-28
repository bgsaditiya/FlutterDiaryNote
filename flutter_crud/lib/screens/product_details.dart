import 'package:flutter/material.dart';

class ProductDetail extends StatelessWidget {
  final Map product;

  const ProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: Column(
        children: [
          Image.network(
            product['image_url'],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp.' + product['price'],
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: const [
                    Icon(Icons.edit),
                    Icon(Icons.delete),
                  ],
                ),
              ],
            ),
          ),
          Text(
            product['description'],
          ),
        ],
      ),
    );
  }
}
