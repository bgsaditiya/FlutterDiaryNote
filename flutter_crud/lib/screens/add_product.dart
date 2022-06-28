import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud/screens/homepage.dart';
import 'package:http/http.dart' as http;

class AddProduct extends StatelessWidget {
  AddProduct({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  //TextEditingController price = TextEditingController();
  TextEditingController imageUrl = TextEditingController();

  Future saveProduct() async {
    var url = 'http://127.0.0.1:8000/api/products/';
    var response = await http.post(Uri.parse(url), body: {
      "name": name.text,
      "description": description.text,
      //"price": price.text,
      "image_url": imageUrl.text,
    });
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: "Name"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: description,
              decoration: const InputDecoration(labelText: "Description"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product description';
                }
                return null;
              },
            ),
            // TextFormField(
            //   controller: price,
            //   decoration: const InputDecoration(labelText: "Price"),
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter product price';
            //     }
            //     return null;
            //   },
            // ),
            TextFormField(
              controller: imageUrl,
              decoration: const InputDecoration(labelText: "Image Url"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter product image';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  saveProduct().then((value) => null);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product berhasil ditambah'),
                    ),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
