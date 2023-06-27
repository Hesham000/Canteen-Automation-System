import 'dart:io';
import 'package:orders/Constant/Appcolours.dart';
import 'package:flutter/material.dart';
import 'package:orders/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orders/widgets/custombutton.dart';
class userform extends StatefulWidget {
  //const userform({super.key});

  @override
  State<userform> createState() => _userformState();
}

class _userformState extends State<userform> {
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
  List<String> gender = ["Male", "Female", "Other"];

  Future uploadimg() async {
    Reference ref =
        FirebaseStorage.instance.ref('profile/').child('$_fileName');
    await ref.putFile(_image!);
    url = await ref.getDownloadURL();
    print(url);
  }

  Future<void> _selectDateFromPicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(DateTime.now().year - 30),
      lastDate: DateTime(DateTime.now().year),
    );
    if (picked != null)
      setState(() {
        _dobController.text = "${picked.day}/ ${picked.month}/ ${picked.year}";
      });
  }

  sendUserDataToDB() async {
    Reference ref =
        FirebaseStorage.instance.ref('profile/').child('$_fileName');
    await ref.putFile(_image!);
    url = await ref.getDownloadURL();
    print(url);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;

    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection("users-form-data");
    return _collectionRef
        .doc(currentUser!.email)
        .set({
          "name": _nameController.text,
          "email": _emailController.text,
          "phone": _phoneController.text,
          "dob": _dobController.text,
          "gender": _genderController.text,
          "age": _ageController.text,
          "img": url,
        })
        .then((value) => {
              Fluttertoast.showToast(msg: "Successful"),
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const loginscreen()))
            })
        .catchError((error) => print("something is wrong. $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 100, top: 10, right: 30, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //Container(
                      //   decoration: const BoxDecoration(
                      //       gradient: LinearGradient(colors: [
                      //     Color.fromARGB(255, 59, 59, 59),
                      //     Color(0xFFFF9900),
                      //   ], begin: Alignment.topCenter, end: Alignment.center)),
                      // ),
                      CircleAvatar(
                        backgroundImage: const AssetImage('assets/Logo.jpeg'),
                        radius: MediaQuery.of(context).size.height / 13,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Submit the form to continue.",
                  style: TextStyle(
                      fontSize: 25.sp,
                      color: const Color.fromARGB(245, 175, 25, 17),
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "We will not share your information with anyone.",
                  style: TextStyle(
                    fontSize: 14.sp,
                    //color: Color(0xFFBBBBBB),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: 15.h,
                ),
                // myTextField(
                //     "enter your name", TextInputType.text, _nameController),
                TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.account_circle),
                    iconColor: Colors.orange,
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color:const Color.fromARGB(245, 175, 25, 17),
                    ),
                    hintText: "Enter your name",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                // myTextField("enter your phone number", TextInputType.number,
                //     _phoneController),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.email),
                    iconColor: Colors.orange,
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: const Color.fromARGB(245, 175, 25, 17),
                    ),
                    hintText: "Enter your Email again",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.phone),
                    iconColor: Colors.orange,
                    labelText: 'Phone',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: const Color.fromARGB(245, 175, 25, 17),
                    ),
                    hintText: "Enter your phone number",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _dobController,
                  readOnly: true,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.baby_changing_station_sharp),
                    iconColor: Colors.orange,
                    labelText: 'Date of birth',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: const Color.fromARGB(245, 175, 25, 17),
                    ),
                    hintText: "Enter your date of birth",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () => _selectDateFromPicker(context),
                      icon: const Icon(Icons.calendar_today_outlined),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.woman),
                    iconColor: Colors.orange,
                    hintText: "choose your gender",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                    labelText: 'Gender',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: const Color.fromARGB(245, 175, 25, 17),
                    ),
                    suffixIcon: DropdownButton<String>(
                      items: gender.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                          onTap: () {
                            setState(() {
                              _genderController.text = value;
                            });
                          },
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: const Icon(Icons.lock_clock),
                    iconColor: Colors.orange,
                    labelText: 'Age',
                    labelStyle: TextStyle(
                      fontSize: 20.sp,
                      color: const Color.fromARGB(245, 175, 25, 17),
                    ),
                    hintText: "Enter your age",
                    hintStyle: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                    width: 250,
                    height: 250,
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
                                      child: Text("Select the item image"),
                                    )
                                  : Image.file(_image!))
                        ],
                      ),
                    )),
                // ),
                ElevatedButton(
                  onPressed: () async {
                    final pick = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    setState(() {
                      if (pick != null) {
                        _image = File(pick.path);
                        _fileName = pick.name;
                        if (_image != null) {
                          uploadimg().whenComplete(() => const SnackBar(
                                content: Text("Picture is selected"),
                                duration: Duration(milliseconds: 400),
                              ));
                        }
                      } else {
                        final snackBar = const SnackBar(
                          content: Text("No image selected"),
                          duration: Duration(milliseconds: 400),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.grey),
                  child: const Text(
                    "Add Image",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),

                // myTextField(
                //     "enter your age", TextInputType.number, _ageController),

                SizedBox(
                  height: 50.h,
                ),

                // elevated button
                customButton("Continue", () => sendUserDataToDB()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}