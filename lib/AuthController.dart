import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytask_app/HomePage.dart';
import 'package:dailytask_app/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Userdata.dart';

class AuthController extends GetxController{
  static AuthController get instance => Get.find();

  final _auth = FirebaseAuth.instance;
late  Rx<User?> firebaseUser;
@override
void onReady () {
  Future.delayed(Duration(seconds: 10));
firebaseUser = Rx<User?> (_auth.currentUser);
firebaseUser.bindStream(_auth.userChanges());
ever (firebaseUser, _setInitialScreen);
}

_setInitialScreen (User? user) {
user == null ? Get.offAll(() => LoginPage()): Get.offAll(() => HomePage());
}
Future<UserCredential?> registerdata(String email, String password) async {
try {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  } catch (e) {
    Get.snackbar("Error", "Registrasi gagal : $e", snackPosition: SnackPosition.TOP, backgroundColor: Colors.red, colorText: Colors.white);
    return null; // Return null in case of an error
  }
}
Future<UserCredential?> loginWithEmailAndPassword (String email, String password) async {
  try{
    return await _auth.signInWithEmailAndPassword (email: email, password: password);
  }catch(e){
      Get.snackbar("Error", "Username / password salah",snackPosition: SnackPosition.TOP,backgroundColor: Colors.red, colorText: Colors.white);
  } 
       return null;
}
Future<void> logout() async => await _auth.signOut();

  Usermodel? userdata() {}
  // String? get user => firebaseAuth.currentUser!.email;

  // final email = TextEditingController();
  // final password = TextEditingController();
  // final username = TextEditingController();
  // final loading = false;

  
  
}
class signup extends GetxController{
  static signup get instance => Get.find();
  final userdata =  Get.put(user());
  final Auth = Get.put(AuthController());
final email = TextEditingController();
final password = TextEditingController();
final username = TextEditingController();
final retypePassword= TextEditingController();
final errorMessage = RxString(''); 
final isregister = false.obs;

Future<void> register(Usermodel user)async{
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: user.username)
          .get();
      if(querySnapshot.docs.isNotEmpty){
        Get.snackbar("Error!!", "Username sudah ada",snackPosition: SnackPosition.TOP,backgroundColor: Colors.red, colorText: Colors.white);
        isregister(false);
      }else{
        final userx =  await Auth.registerdata(user.Email, user.password);
        user.id = userx!.user!.uid;
        await userdata.saveUserRecord(user);
        
             Get.snackbar("Success","registrasi Berhasil",snackPosition: SnackPosition.TOP,backgroundColor: Colors.green, colorText: Colors.white);
             isregister(false);
             Get.to(LoginPage());
      }
    }catch(e){
      Get.snackbar("Error", "Registrasi gagal : $e",snackPosition: SnackPosition.TOP,backgroundColor: Colors.red, colorText: Colors.white);
      isregister(false);
    }
}
}
class sigin extends GetxController{
  final email = TextEditingController();
  final password = TextEditingController();
   final Auth = Get.put(AuthController());
   final userx = Get.put(user());

   final islogin = false.obs;
  Future<void> Login() async{
    islogin(true);
    if(email.text.isEmpty && password.text.isEmpty){
        Get.snackbar("Warning!!", "tidak boleh kosong",snackPosition: SnackPosition.TOP,backgroundColor: Colors.red, colorText: Colors.white);
        islogin(false);
    }else{
    UserCredential? userxx = await Auth.loginWithEmailAndPassword(email.text.trim(), password.text.trim());
    if(userxx == null){
       islogin(false);
       email.clear();
       password.clear();
    }else{
     islogin(false);
     email.clear();
     password.clear();
     Auth.firebaseUser.value = userxx!.user;
     Get.to(HomePage());
    }
    }
  }
}