import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class FirebaseServices {
  Future<List<QueryDocumentSnapshot>> fetchAllcategoriesData() async {
    List<QueryDocumentSnapshot> documentSnapshot = [];
    try {
      const Center(child: CircularProgressIndicator());
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("all-categories").get();
      documentSnapshot = snapshot.docs;
      Get.back();
      return documentSnapshot;
    } catch (e) {
      Get.back();
      print(e.toString());
    } finally {
      Get.back();
    }
    return documentSnapshot;
  }
}
