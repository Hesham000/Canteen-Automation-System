import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orders/screen/bottom_nav_controller.dart';
Widget fetchRecommendations(String collectionName) {
  return Container(
    child: Stack(
      children: <Widget>[
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName)
              .doc(FirebaseAuth.instance.currentUser!.uid) // use uid instead of email
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something is wrong"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var data = snapshot.data!.data();
            var recommendations = (data as Map)['recommendations'] as List;
            return ListView.builder(
                itemCount: recommendations.length,
                itemBuilder: (_, index) {
                  var recommendation = recommendations[index];

                  return Card(
                    elevation: 5,
                    child: ListTile(
                      title: Text(
                        "Product ID: ${recommendation['product_id']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19.h),
                      ),
                      subtitle: Text(
                        "Rating: ${recommendation['rating'].toString()}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                    ),
                  );
                });
          },
        ),
      ],
    ),
  );
}
