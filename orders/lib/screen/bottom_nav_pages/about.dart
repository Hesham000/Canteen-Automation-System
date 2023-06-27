import 'package:flutter/material.dart';
import 'MDrawer.dart';
class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> with TickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((animationStatus) {
            if (animationStatus == AnimationStatus.completed) {
              _animationController.reset();
              _animationController.forward();
            }
          });
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BFMH Canteen",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.all(20.0),
            // child: CircleAvatar(
            //   backgroundImage: AssetImage("assets/Logo.jpeg"),
            // ),
          ),
        ],
      ),
      drawer: const Drawer(
        child: MDrawer(),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 100, top: 10, right: 30, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: const AssetImage('assets/Logo.jpeg'),
                  radius: MediaQuery.of(context).size.height / 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.all(8)),
          Center(
            child: Container(
              margin: const EdgeInsets.all(15),
              child: RichText(
                text: const TextSpan(
                  text: '\n \n \n \nAbout Our App',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xFFFD8803)),
                  children: <TextSpan>[
                    TextSpan(
                        children: [],
                        text:
                            '\n  \n  There have canteen system food buying.When we go and purchase food there are too many crowd and it wastes our important time.It creates awkward situation.\n \n This Canteen Apps releases us from this problem.We can save our time. We can purchase food in this apps.And we can take our food when it prepared and get notifications.And donot need to stand in queue for taking food.',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF080808))),
                    TextSpan(text: "\n \nContact with us"),
                    TextSpan(
                        text:
                            "\n \n Hesham Ali \n Email : Hesham.aly@msa.edu.eg ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF080808))),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            label: " © MSA Canteen 2023",
            icon: SizedBox(),
          ),
          const BottomNavigationBarItem(
            label: " © Hesham Ali",
            icon: SizedBox(),
          )
        ],
      ),
    );
  }
}