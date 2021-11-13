import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
firebase_storage.FirebaseStorage storage =
  firebase_storage.FirebaseStorage.instance;


Future<void> uploadFile(Uint8List x) async {
  Directory appDocDir = await getApplicationDocumentsDirectory();
  DateTime now = DateTime.now();
  String filePath = appDocDir.absolute.path+'/qrcodeimage'+now.toString()+'.png';
  // // ...
  // // e.g. await uploadFile(filePath);
  print(appDocDir.absolute.path);
  print("Here 1 ");
  File file = File(filePath);
  await file.writeAsBytes(x);
  print("Here 2");
  try {
    await firebase_storage.FirebaseStorage.instance
        .ref('uploads/qrcodeimage'+now.toString()+'.png')
        .putFile(file);
  } on firebase_core.FirebaseException catch (e) {
    // e.g, e.code == 'canceled'
  }
}