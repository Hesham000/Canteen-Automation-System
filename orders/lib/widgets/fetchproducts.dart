import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orders/screen/bottom_nav_controller.dart';
Widget fetchData(String collectionName, num? total) {
  return Container(
    child: Stack(
      children: <Widget>[
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(collectionName)
              .doc(FirebaseAuth.instance.currentUser!.email)
              .collection("items")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something is wrong"),
              );
            }
            return ListView.builder(
                itemCount:
                    snapshot.data == null ? 0 : snapshot.data!.docs.length,
                itemBuilder: (_, index) {
                  DocumentSnapshot _documentSnapshot =
                      snapshot.data!.docs[index];

                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(_documentSnapshot['images']),
                      ),
                      title: Text(
                        " ${_documentSnapshot['name']}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 19.h),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " ${_documentSnapshot['price'].toString()}LE",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                          Visibility(
                            visible: false,
                            child: Text(
                              " ${_documentSnapshot['Product-id']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      trailing: GestureDetector(
                        child: const CircleAvatar(
                          child: Icon(Icons.delete,
                              color: Color.fromARGB(255, 231, 5, 5)),
                        ),
                        onTap: () {
                          FirebaseFirestore.instance
                              .collection(collectionName)
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection("items")
                              .doc(_documentSnapshot.id)
                              .delete()
                              .then((value) => {
                                    Fluttertoast.showToast(
                                        msg: "Successfully Deleted"),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const bottomnavcontroller())),
                                    total = total! - _documentSnapshot['price'],
                                    print(total),
                                  });
                        },
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
