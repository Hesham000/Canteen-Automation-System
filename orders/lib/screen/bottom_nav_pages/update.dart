import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orders/screen/bottom_nav_pages/profile.dart';
import 'package:orders/widgets/custombutton.dart';
class update extends StatefulWidget {
  var data;
  update(this.data);

  @override
  State<update> createState() => _updateState();
}

class _updateState extends State<update> {
  File? _image;
  final imagePicker = ImagePicker();
  String? url;
  String? _fileName;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _imgController = TextEditingController();

  Future uploadimg() async {
    Reference ref =
        FirebaseStorage.instance.ref('profile/').child('$_fileName');
    await ref.putFile(_image!);
    url = await ref.getDownloadURL();
    print(url);
  }

  updateData() async {
    Reference ref =
        FirebaseStorage.instance.ref('profile/').child('$_fileName');
    await ref.putFile(_image!);
    url = await ref.getDownloadURL();
    print(url);
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
          "name": _nameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
          "dob": _dobController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
          "img": url,
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "Successfully Updated"),
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Profile()))
            })
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.orange,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Update information",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: Colors.orange,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.h,
                ),

                Padding(
                  padding:
                      EdgeInsets.only(left: 90, top: 10, right: 30, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                          widget.data["img"],
                          //fit: BoxFit.cover,
                        ),
                        radius: MediaQuery.of(context).size.height / 10,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                // myTextField(
                //     "enter your name", TextInputType.text, _nameController),
                TextField(
                  controller: _nameController =
                      TextEditingController(text: widget.data["name"]),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.account_circle),
                    iconColor: Colors.orange,
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    // hintText: "Enter your name",
                    // hintStyle: TextStyle(
                    //   fontSize: 14.sp,
                    //   color: Colors.grey,
                    // ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // myTextField("enter your phone number", TextInputType.number,
                //     _phoneController),
                TextField(
                  readOnly: true,
                  controller: _emailController =
                      TextEditingController(text: widget.data["email"]),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    iconColor: Colors.orange,
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    // hintText: "Enter your Email again",
                    // hintStyle: TextStyle(
                    //   fontSize: 14.sp,
                    //   color: Colors.grey,
                    // ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _phoneController =
                      TextEditingController(text: widget.data["phone"]),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    iconColor: Colors.orange,
                    labelText: 'Phone',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    // hintText: "Enter your phone number",
                    // hintStyle: TextStyle(
                    //   fontSize: 14.sp,
                    //   color: Colors.grey,
                    // ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _dobController =
                      TextEditingController(text: widget.data["dob"]),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.baby_changing_station_sharp),
                    iconColor: Colors.orange,
                    labelText: 'Date of birth',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),

                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _genderController =
                      TextEditingController(text: widget.data["gender"]),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Icon(Icons.woman),
                    iconColor: Colors.orange,
                    labelText: 'Gender',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _ageController =
                      TextEditingController(text: widget.data["age"]),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock_clock),
                    iconColor: Colors.orange,
                    labelText: 'Age',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.orange,
                    ),
                    // hintText: "Enter your age",
                    // hintStyle: TextStyle(
                    //   fontSize: 14.sp,
                    //   color: Colors.grey,
                    // ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: _image == null
                                  ? const Center(
                                      child: Text(""),
                                    )
                                  : Image.file(_image!))
                        ],
                      ),
                    )),
                ElevatedButton(
                  onPressed: () async {
                    final pick = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {
                      if (pick != null) {
                        _image = File(pick.path);
                        _fileName = pick.name;
                        if (_image != null) {
                          uploadimg().whenComplete(() => SnackBar(
                                content: Text("Picture is selected"),
                                duration: Duration(milliseconds: 400),
                              ));
                        }
                      } else {
                        final snackBar = SnackBar(
                          content: Text(""),
                          duration: Duration(milliseconds: 400),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  child: Text(
                    "update Image",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50.h,
                ),

                // elevated button
                customButton("Added", () => updateData()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
