import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orders/screen/login_screen.dart';
class welcomescreen extends StatefulWidget {
  const welcomescreen({super.key});

  @override
  State<welcomescreen> createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/dash2.jpg'), fit: BoxFit.cover),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Padding(
                  padding: const EdgeInsets.only(top: 170, left: 40),
                  child: Column(
                    children: [
                      const Text(
                        'Order Canteen',
                        style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              BoxShadow(
                                blurRadius: 5,
                                color: Colors.orange,
                                offset: Offset(3, 3),
                              )
                            ]),
                      ),
                      Text(
                        ' MSA University',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[200],
                            shadows: [
                              const BoxShadow(
                                blurRadius: 5,
                                color: Colors.orange,
                                offset: Offset(2, 2),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 25, left: 80, right: 24),
                      child: Text(
                        'Where tasteful creations begin',
                        style: GoogleFonts.lobster(
                          fontSize: 18,
                          color: Colors.grey[200],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    // ),
                    Container(
                      height: 80,
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          top: 8, left: 44, right: 44, bottom: 10),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const loginscreen()));
                        },
                        style: TextButton.styleFrom( elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                        backgroundColor: Colors.orange,),
                        child: const Text(
                          'Student',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
