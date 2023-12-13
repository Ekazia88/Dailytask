import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytask_app/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class user extends GetxController{
  static user get instance => Get.find();
  final auth = Get.put(AuthController());
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final userdata = Rxn<Usermodel?>();

  saveUserRecord(Usermodel user) async {
    await db.collection("Users").doc(user.id).set(user.toJson()).whenComplete((){
      Get.snackbar("Succes", "Anda berhasil Tambahkan data",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      );
    }).catchError((error, StackTrace){
      Get.snackbar("Error","ada yg salah, coba lagi",
      snackPosition:SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      colorText: Colors.red,
      );
      print("Error :  $error");
    });
  }
 
  Future <Usermodel?> getUserdetails(String email) async{
        final snapshot = await db.collection("Users").where("email", isEqualTo: email).get();
        final itemdata = snapshot.docs.map((e) => Usermodel.fromSnapshot(e)).single;
        print("yes ${itemdata}");
        return itemdata;
      }
    // Future<Usermodel?> getUserdata() async {
    // String? email = auth.firebaseUser.value?.email;
    // if (email != null) {
    //   userdata = await getUserdetails(email);
    // }
    // }
  }
    
class Usermodel{
  late String? id;
  final String username;
  final String Email;
  final String password;

  Usermodel({
    this.id,
    required this.username,
    required this.Email,
    required this.password,
  });

  toJson(){
    return {
      "username": username, "email": Email, "password": password,};
    }

    factory Usermodel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
      final data = document.data()!;
      return Usermodel(
        username: data["username"],
        Email: data["Email"],
        password: data["Date"],
      );
    }
}