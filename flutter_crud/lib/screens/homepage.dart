import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_crud/screens/add_product.dart';
import 'package:flutter_crud/screens/product_details.dart';

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.message,
    required this.data,
  });

  String message;
  List<Datum> data;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String description;
  String imageUrl;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        imageUrl: json["image_url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image_url": imageUrl,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'http://127.0.0.1:8000/api/products/';
  Future<Welcome> getProducts() async {
    var response = await http.get(Uri.parse(url));
    return Welcome.fromJson(json.decode(response.body));
  }

  Future deleteProduct(String productId) async {
    String url = 'http://127.0.0.1:8000/api/products/$productId';

    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    getProducts();
    return Scaffold(
      backgroundColor: const Color(0xff151515),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 239, 138, 95),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        child: const Icon(
          Icons.add,
          color: Color.fromARGB(230, 0, 0, 0),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      appBar: AppBar(
        backgroundColor: const Color(0xff151515),
        title: const Text('Diary Note'),
      ),
      body: (FutureBuilder<Welcome>(
        future: getProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final lol = snapshot.data!;
            return ListView.builder(
                itemCount: lol.data.length,
                itemBuilder: (context, index) {
                  String string = '${lol.data[index].createdAt}';
                  var result = string.substring(0, 19);
                  return SizedBox(
                    height: 180,
                    child: Card(
                      color: const Color.fromARGB(230, 73, 72, 72),
                      elevation: 5,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                      product: lol.data[index]
                                          as Map<String, dynamic>,
                                    ),
                                  ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                height: 120,
                                width: 120,
                                child: Image.network(
                                  lol.data[index].imageUrl,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    lol.data[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    lol.data[index].description,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        result,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // GestureDetector(
                                          //   onTap: () {
                                          //     Navigator.push(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             EditProduct(
                                          //           product: lol.data[index]
                                          //               as Map<String, dynamic>,
                                          //         ),
                                          //       ),
                                          //     );
                                          //   },
                                          //   child: const Icon(
                                          //     Icons.edit,
                                          //     color: Colors.white,
                                          //   ),
                                          // ),
                                          GestureDetector(
                                            onTap: () {
                                              deleteProduct(lol.data[index].id
                                                      .toString())
                                                  .then((value) {
                                                setState(() {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Product berhasil dihapus'),
                                                    ),
                                                  );
                                                });
                                              });
                                            },
                                            child: const Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text('Loading'),
            );
          }
        },
      )),
    );
  }
}
