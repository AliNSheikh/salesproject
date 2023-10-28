import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salesproject/login_screen.dart';
import 'package:salesproject/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminController {
  static int number = 1;
  static var allUsers = [];
  static Future<void> getNewUserNumber() async {
    var users = await FirebaseFirestore.instance.collection('users').get();
    if (users.docs.isEmpty) {
      print('no users');
      return;
    } else {
      for (var element in users.docs) {
        print(element.data());
        if (element.data()['number'] >= number) {
          number = element.data()['number'] + 1;
          print('number is $number');
        }
      }
    }
    print(number);
  }

  static Future<void> addUser(
      {required name,
      required email,
      required living,
      required number,
      required region,
      required password,
      required image}) async {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    var userImageUrl = await uploadUserImage(image);
    UserModel model = UserModel(
      name: name,
      email: email,
      living: living,
      number: int.parse(number),
      region: region,
      image: userImageUrl,
      date: formattedDate.toString(),
      password: password,
    );
    await FirebaseFirestore.instance
        .collection('users')
        .doc(number)
        .set(model.toMap());
  }

  static Future<String> uploadUserImage(File userImage) async {
    var imageUploadTask = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(userImage.path).pathSegments.last}')
        .putFile(userImage);

    String imageUrl = await imageUploadTask.ref.getDownloadURL();
    return imageUrl;
  }

  static void logOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) {
          return false;
        },
      );
    });
  }

  static Future deleteUser(userNumber) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userNumber)
        .delete();
  }

  static Future<void> editUser({
    required name,
    required number,
    required email,
    required living,
    required region,
    required password,
    required isImageEdited,
    File? image,
  }) async {
    print('$number and ${number.runtimeType}');

    if (isImageEdited) {
      var userImageUrl = await uploadUserImage(image!);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(number.toString())
          .update({
        'name': name,
        'email': email,
        'password': password,
        'living': living,
        'region': region,
        'image': userImageUrl,
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(number.toString())
          .update({
        'name': name,
        'email': email,
        'password': password,
        'living': living,
        'region': region,
      });
    }
  }

  static Future<Map<String, dynamic>> getUserCommition(
      {required userNumber, required year, required month}) async {
    Map<String, dynamic> userMonthlyCommition = {
      'coastalRegion': 0,
      'easternRegion': 0,
      'lebanonRegion': 0,
      'northernRegion': 0,
      'southernRegion': 0,
      'totalCommition': 0,
    };
    var userCommition = await FirebaseFirestore.instance
        .collection('sellsCommition')
        .where('number', isEqualTo: userNumber)
        .where('year', isEqualTo: int.parse(year))
        .where('month', isEqualTo: int.parse(month))
        .get();
    for (var element in userCommition.docs) {
      userMonthlyCommition['coastalRegion']+= element.data()['coastalRegion'];
      userMonthlyCommition['easternRegion']+= element.data()['easternRegion'];
      userMonthlyCommition['lebanonRegion']+= element.data()['lebanonRegion'];
      userMonthlyCommition['northernRegion']+= element.data()['northernRegion'];
      userMonthlyCommition['southernRegion']+= element.data()['southernRegion'];
    }
    userMonthlyCommition['totalCommition']=userMonthlyCommition['coastalRegion'] +userMonthlyCommition['easternRegion']
        +userMonthlyCommition['lebanonRegion']+userMonthlyCommition['northernRegion']+userMonthlyCommition['southernRegion'];
    return userMonthlyCommition;
  }
}
