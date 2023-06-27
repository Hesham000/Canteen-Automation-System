import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:orders/screen/product_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RecommendedProducts extends StatefulWidget {
  @override
  _RecommendedProductsState createState() => _RecommendedProductsState();
}
//recommendation
class _RecommendedProductsState extends State<RecommendedProducts> {
  final List<String> _carouselImages = [];
  final _firestoreInstance = FirebaseFirestore.instance;

  fetchCarouselImages() async {
    QuerySnapshot qn =
        await _firestoreInstance.collection("carousel-slider").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(
          qn.docs[i]["img-path"],
        );
        // print(qn.docs[i]["img-path"]);
      }
    });

    return qn.docs;
  }

  Future<List<DocumentSnapshot<Object?>>> fetchRecommendedProducts() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final uid = user?.uid;

    QuerySnapshot recommendationSnap = await _firestoreInstance
        .collection('recommendations')
        .where('user_id', isEqualTo: uid)
        .get();

    print('recommendationSnap.docs.length: ${recommendationSnap.docs.first.id}');
    if (recommendationSnap.docs.isEmpty) {
      print('No recommendations found for this user');
    }
    // from recommendations array get all product ids
    List<String> productIds = [];
    for (var doc in recommendationSnap.docs) {
      // loop in recommendations array and get all product ids
      for (Map A in doc['recommendations']) {
        productIds.add(A['product_id']);
        print('productId: ${A['product_id']}');
      }
    }

    // get all products from products collection where id in productIds
    List<DocumentSnapshot> productDocs = [];
    for (var id in productIds) {
      QuerySnapshot qn = await _firestoreInstance
          .collection('products')
          .where('product-id', isEqualTo: id)
          .get();
      productDocs.add(qn.docs.first);
      print('productDocs: ${qn.docs.first['product-name']}');
    }
    return productDocs;
  }

  List<DocumentSnapshot> productDocs = [];

  @override
  void initState() {
    fetchCarouselImages();
    fetchRecommendedProducts().then((value) {
      setState(() {
        productDocs = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        scrollDirection: Axis.vertical,
        itemCount: productDocs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 1),
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        ProductDetails(productDocs[index]))),
            child: Card(
              elevation: 3,
              child: Column(
                children: [
                  AspectRatio(
                      aspectRatio: 1.5,
                      child: Container(
                          color: Colors.yellow,
                          child: Image.network(
                            productDocs[index]["product-img"],
                            fit: BoxFit.cover,
                          ))),
                  Text(
                    "${productDocs[index]["product-name"]}",
                    style: const TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0),
                  ),
                  Text(
                    "${productDocs[index]["product-price"].toString()} LE",
                    style: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      //fontSize: 18.0
                    ),
                  ),
                  Text(
                    "${productDocs[index]["product-available"]}",
                    style: const TextStyle(
                        //fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 10.0),
                  ),
                ],
              ),
            ),
          );
        }),
    );
  }
}