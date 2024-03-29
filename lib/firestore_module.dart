import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

// CollectionReference farmers =
//     FirebaseFirestore.instance.collection('farmersDB/0/farmers');
//     CollectionReference qrDB = FirebaseFirestore.instance.collection('qrDB');
CollectionReference usersDB = FirebaseFirestore.instance.collection('users');
Future<String> getUserType(String userId) async {
  var userList = await usersDB.get().then(
    (res) {
      print("Successfully completed: ");
      // res.docs.forEach((element) async {
      //   print(element.id);
      // });
      List<dynamic> result = res.docs.map((doc) => doc.data()).toList();
      return result;
    },
    onError: (e) => print("Error completing: $e"),
  );
  print(userList[0].toString());
  for (var usr in userList) {
    // print(usr['userType']);
    if (usr['email'] == userId) return usr['userType'];
  }
  return 'User does not exist';
}

Future<String> addUser(emailId, pass, userType) async {
  var msg = '';
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: emailId, password: pass);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      msg = 'The password provided is too weak.';
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      msg = 'The password provided is too weak.';
    }
  } catch (e) {
    print(e);
    msg = e.toString();
  } finally {
    if (msg != '') return msg;
  }

  final data = {"email": emailId, "userType": userType};

  msg = await usersDB.add(data).then((documentSnapshot) {
    return "Added Data with ID: ${documentSnapshot.id}";
  }, onError: (e) {
    return "Error completing: $e";
  });
  return msg;
}
// Future<String> addFarmer(fullName, phoneNo, addr, city, state, pin) async {
//   // Call the user's CollectionReference to add a new user
//   var counter =
//       await farmerDB.doc('0').get().then((DocumentSnapshot documentSnapshot) {
//     if (documentSnapshot.exists) {
//       print('Document data: ${documentSnapshot.data()}');
//       return documentSnapshot.data() as Map<String, dynamic>;
//     } else {
//       print('Document does not exist on the database');
//       return {};
//     }
//   });
//   print("here 1" + counter.toString());
//   var usersAdded = counter['usersAdded'];
//   var fid = 'SCQR' + (usersAdded + 1).toString();
//   await farmers
//       .doc(fid)
//       .set({
//         'Full Name': fullName, // John Doe
//         'Phone Number': phoneNo, // Stokes and Sons
//         'Address': addr, // 42
//         'City': city, // 42
//         'State': state, // 42
//         'Pin Code': pin, // 42
//       })
//       .then((value) => print("Farmer added : " + fid))
//       .catchError((error) => print("Failed to add user: $error"));
//   await farmerDB.doc('0').set({
//     'usersAdded': (usersAdded + 1),
//     'usersRemoved': counter['usersRemoved']
//   });
//   return fid;
// }

// Future<void> addQrScan(List dataList) async {
//   // Call the user's CollectionReference to add a new user
//   print("Called addQrScan");
//   await qrDB
//       .add({
//         'Farmer ID': dataList[0], // John Doe
//         'Product': dataList[1], // Stokes and Sons
//         'Cost Per Item': dataList[2], // 42
//         'Items per Box': dataList[3], // 42
//         'Location': dataList[4],
//         'Timestamp': DateTime.now() // 42
//       })
//       .then((value) => print("Scanned and Updated DB"))
//       .catchError((error) => print("Failed to add user: $error"));
// }
