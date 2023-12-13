import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytask_app/DetailTask.dart';
import 'package:dailytask_app/Userdata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class itemRepo extends GetxController{
  static itemRepo get instance => Get.find();
  final usercontroller = Get.put(user());
  final db =  FirebaseFirestore.instance;
  
  CreateData(TaskItemModel taskItemModel, String uid) async{
    await db.collection("Users").doc(uid).collection("Dailytask").doc().set(taskItemModel.toJson()).whenComplete((){
      Get.snackbar("Succes", "Anda berhasil Tambahkan data",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green,
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
  DataDetail(TaskItemModel taskItemModel) async{

    Future <TaskItemModel> getDetail(String title,String uid) async {
      final snapshot = await db.collection("Users").doc(uid).collection("Dailytask").where("Title", isEqualTo: title).get();
      final itemdata =  snapshot.docs.map((e) => TaskItemModel.fromSnapshot(e)).single;
      return itemdata;
    }
  }
  Future<List<TaskItemModel>> allitem(String uid) async{
      final Snapshot = await db.collection("Users").doc(uid).collection("Dailytask").get();
      final itemdata = Snapshot.docs.map((e) => TaskItemModel.fromSnapshot(e)).toList();
      return itemdata;
    }
   Future<void> updateTask(TaskItemModel taskItemModel,String uid) async{
      await db.collection("Users").doc(uid).collection("Dailytask").doc(taskItemModel.id).update(taskItemModel.toJson());
    }
    Future<void> deleteTask(TaskItemModel taskItemModel, String uid) async{
      await db.collection("Users").doc(uid).collection("Dailytask").doc(taskItemModel.id).delete();
    }
}
