import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:orders/Constant/Appcolours.dart';
import 'package:orders/screen/welcome_screen.dart';
class SplahScreen extends StatefulWidget {
  const SplahScreen({super.key});

  @override
  State<SplahScreen> createState() => _SplahScreenState();
}

class _SplahScreenState extends State<SplahScreen> {
  @override
  void initState() {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.push(
            context, CupertinoPageRoute(builder: (_) => welcomescreen())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.flareGradient,
              ),
            ),
       SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Order Canteen",
                style: GoogleFonts.lobster(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 44.sp),
              ),
              SizedBox(height: 10.h),
              CircleAvatar(
                backgroundImage: const AssetImage("assets/Logo.jpeg"),
                radius: MediaQuery.of(context).size.height / 10,
              ),
              //CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    ]
    )
    );
  }
}