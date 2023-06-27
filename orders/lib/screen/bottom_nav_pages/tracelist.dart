import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  List<String> ratedOrderIds = [];

  Widget buildOrdersList() {
    String? email = FirebaseAuth.instance.currentUser?.email;
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("order")
            .where("email", isEqualTo: email)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No orders found"),
            );
          }
          return Builder(
            builder: (context) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final order = snapshot.data!.docs[index];
                  final orderId = order.id;
                  final isOrderRated = ratedOrderIds.contains(orderId);

                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("assets/profile.png"),
                      ),
                      title: Text(
                        "Order ${index + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                          fontSize: 19,
                        ),
                      ),
                      subtitle: Text(
                        "Item: ${order['item_name']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      trailing: isOrderRated
                          ? const Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Text(
                                'Rated',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total: ${order['total']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemSize: 20.0,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) async {
                                      print('Rating: $rating');
                                      sendRatingToFirebase(
      order['user_id'], order['product_id'], rating);
  removeOrderFromFirebase(orderId);
  setState(() {
    ratedOrderIds.add(orderId);
    snapshot.data!.docs.removeAt(index);
  });
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Order rated and removed"),
    ),
  );
},
                                ),
                              ],
                            ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void removeOrderFromFirebase(String orderId) async {
  try {
    await FirebaseFirestore.instance.collection('order').doc(orderId).delete();
    print('Order removed from Firebase');
  } catch (e) {
    print('Error removing order from Firebase: $e');
  }
}

  void sendRatingToFirebase(String userId, String productId, double rating) async {
    try {
      await FirebaseFirestore.instance.collection('ratings').add({
        'user_id': userId,
        'product_id': productId,
        'rating': rating,
      });
      print('Rating added to Firebase');
    } catch (e) {
      print('Error adding rating to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
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
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: buildOrdersList(),
      ),
    );
  }
}
