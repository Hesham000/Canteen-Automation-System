import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orders/screen/bottom_nav_pages/QRcode.dart';
import 'package:orders/widgets/fetchproducts.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  num? total = 0;
  String? item;
  List<Map<String, dynamic>> products = [];
  String? qrr;

  @override
  void initState() {
    Amount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Cart",
          style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
              shadows: [
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.black,
                  offset: Offset(3, 3),
                )
              ]),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: fetchData("users-cart-items", total),
      ),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          await showPaymentDialog();
        },
        child: const Text("Pay Total"),
      ),
    );
  }

  Amount() async {
    QuerySnapshot qn = await FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .get();
    setState(() {
      if (total != null) {
        for (int i = 0; i < qn.docs.length; i++) {
          total = (total! + qn.docs[i]["price"]);
          products.add({
            'name': qn.docs[i]["name"],
            'id': qn.docs[i].id,
            'price': qn.docs[i]["price"],
            'product-id': qn.docs[i]["Product-id"],
          });
        }
      } else {}
    });
    print(products);
    return total.toString();
  }

  deletee() async {
    FirebaseFirestore.instance
        .collection("users-cart-items")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("items")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
        total = null;
      });
    });
  }

 sendUserDataToDB() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var currentUser = _auth.currentUser;
  String? email = FirebaseAuth.instance.currentUser!.email;

  CollectionReference cartRef = FirebaseFirestore.instance
      .collection("users-cart-items")
      .doc(currentUser!.email)
      .collection("items");

  CollectionReference orderRef = FirebaseFirestore.instance.collection("order");

  for (var product in products) {
    orderRef
        .doc()
        .set({
          "item_name": product['name'],
          "product_id": product['product-id'],
          "user_id": currentUser.uid,
          "total": product['price'],
          "email": email,
        })
        .then((value) => {
          print(qrr),
          qr(),
        })
        .catchError((error) => print("Something went wrong: $error"));
  }
}



  Future<void> showPaymentDialog() async {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Payment"),
              content: Text("Total amount to pay: $total"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    await sendUserDataToDB();
                    deletee();
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                      Text("Payment Successfull"),
                                    ],
                                  ),
                                ],
                              ),
                            ));
                  },
                  child: Text("Pay"),
                ),
              ],
            ));
  }
}
