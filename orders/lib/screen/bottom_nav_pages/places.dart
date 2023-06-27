import 'dart:convert';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orders/screen/bottom_nav_pages/home.dart';
import 'package:orders/screen/product_detail_screen.dart';
import 'package:http/http.dart' as http;
class Places extends StatefulWidget {
  const Places({super.key});

  @override
  State<Places> createState() => _PlacesState();
}

class _PlacesState extends State<Places> {

  var _dotPosition = 0;
  List _Places = [];
  var _firestoreInstance = FirebaseFirestore.instance;


  fetchPlaces() async {
    QuerySnapshot qn = await _firestoreInstance.collection("places").get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _Places.add({
          "place-name": qn.docs[i]["place-name"],
          "place-img": qn.docs[i]["place-img"],
          "place-category":qn.docs[i]["place-category"],
        });
      }
    });

    return qn.docs;
  }
  @override
  void initState() {
    fetchPlaces();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Places",
          style: TextStyle(
            //fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.orange,
        //automaticallyImplyLeading: false,
        //centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SafeArea(
          child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _Places.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 1),
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                          const Home())),
                      child: Card(
                        elevation: 3,
                        child: Column(
                          children: [
                            AspectRatio(
                                aspectRatio: 1.5,
                                child: Container(
                                    color: Colors.yellow,
                                    child: Image.network(
                                      _Places[index]["place-img"],
                                      fit: BoxFit.cover,
                                    ))),
                            Text(
                              "${_Places[index]["place-name"]}",
                              style: const TextStyle(
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      )),
    );
  }
}