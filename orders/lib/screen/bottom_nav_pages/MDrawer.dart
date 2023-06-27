import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orders/screen/bottom_nav_controller.dart';
import 'package:orders/screen/bottom_nav_pages/feedback.dart';
import 'package:orders/screen/bottom_nav_pages/places.dart';
import 'package:orders/screen/bottom_nav_pages/profile.dart';
import 'package:orders/screen/bottom_nav_pages/traces.dart';
import 'package:orders/screen/feedbacess.dart';
import 'package:orders/screen/welcome_screen.dart';
import 'about.dart';
class MDrawer extends StatefulWidget {
  const MDrawer({super.key});

  @override
  State<MDrawer> createState() => _MDrawerState();
}

class _MDrawerState extends State<MDrawer> {
  setDataToTextField(data) {
    final _height = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: const EdgeInsets.all(0),
              margin: const EdgeInsets.all(0),
              child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.orange,
                ),
                margin: const EdgeInsets.all(0),
                accountName: Text(data['name'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    )),
                accountEmail: Text(data['email'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    )),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    data["img"],
                  ),
                  radius: MediaQuery.of(context).size.height / 1,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                CupertinoIcons.home,
                color: Colors.black,
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const bottomnavcontroller(),
                    ),
                  );
                },
                child: const Text(
                  "Home",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(indent: 15, endIndent: 15),
            ListTile(
              leading: const Icon(
                CupertinoIcons.placemark,
                color: Colors.black,
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Places(),
                    ),
                  );
                },
                child: const Text(
                  "Places",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(indent: 18, endIndent: 16),
            ListTile(
              leading: const Icon(
                CupertinoIcons.person_crop_circle,
                color: Colors.black,
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(),
                    ),
                  );
                },
                child: const Text(
                  "Profile",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(indent: 15, endIndent: 15),
            ListTile(
              leading: const Icon(
                CupertinoIcons.cart_fill,
                color: Colors.black,
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const traces(),
                    ),
                  );
                },
                child: const Text(
                  "My Orders queue",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(indent: 15, endIndent: 15),
            ListTile(
              leading: const Icon(
                CupertinoIcons.f_cursive_circle_fill,
                color: Colors.black,
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedBack(),
                    ),
                  );
                },
                child: const Text(
                  "FeedBack",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(indent: 15, endIndent: 15),
            ListTile(
              leading: const Icon(
                CupertinoIcons.list_number,
                color: Colors.black,
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FeedBackSee(),
                    ),
                  );
                },
                child: const Text(
                  "FeedBack List",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(indent: 16, endIndent: 16),
            ListTile(
              leading: const Icon(
                CupertinoIcons.app_badge,
                color: Colors.black,
              ),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutUs(),
                    ),
                  );
                },
                child: const Text(
                  "About Us",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const Divider(indent: 16, endIndent: 16),
            const SizedBox(
              height: 220,
            ),
            ListTile(
              // leading: const Icon(
              //   CupertinoIcons.archivebox_fill,
              //   color: Colors.red,
              // ),
              title: Container(
                color: Colors.orange,
                child: MaterialButton(
                  onPressed: () {
                    logout(context);
                  },
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    "Logout",

                    //textAlign: TextAlign.center,
                    style: TextStyle(
                        //backgroundColor: Colors.redAccent,
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      //   child: Padding(
      // padding: const EdgeInsets.all(1),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users-form-data")
            .doc(FirebaseAuth.instance.currentUser!.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          var data = snapshot.data;
          if (data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return setDataToTextField(data);
        },
      ),
    ));
  }

  //the logout function
  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const welcomescreen()));
  }
}
