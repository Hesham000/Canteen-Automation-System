
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orders/screen/bottom_nav_pages/MDrawer.dart';
import 'package:orders/screen/bottom_nav_pages/cart.dart';
import 'package:orders/screen/bottom_nav_pages/favourite.dart';
import 'package:orders/screen/bottom_nav_pages/recommedation.dart';
import 'package:orders/screen/bottom_nav_pages/tracelist.dart';
import 'package:orders/screen/serach_screen.dart';
import 'bottom_nav_pages/home.dart';
class bottomnavcontroller extends StatefulWidget {
  const bottomnavcontroller({super.key});

  @override
  State<bottomnavcontroller> createState() => _bottomnavcontrollerState();
}

class _bottomnavcontrollerState extends State<bottomnavcontroller> {
  final _pages = [Home(), Favourite(), Cart(), OrdersPage(), RecommendedProducts()];
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: myDrawer(),
      drawer: const Drawer(child: MDrawer()),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 0,
        title: const Text(
          "MSA",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: const CircleAvatar(
                child: Icon(
                  Icons.search,
                  size: 22.0,
                  color: Colors.black,
                ),
                radius: 20.0,
                backgroundColor: Colors.orange,
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        selectedItemColor: Colors.orange,
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        selectedLabelStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: "Favourite"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recommend),
            label: "Recommendations",
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            print(_currentIndex);
          });
        },
      ),
      body: _pages[_currentIndex],
    );
  }
}