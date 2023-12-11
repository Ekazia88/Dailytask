import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dailytask_app/DetailTask.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class itemRepo extends GetxController{
  static itemRepo get instance => Get.find();

  final db =  FirebaseFirestore.instance;

  CreateData(TaskItemModel taskItemModel) async{
    await db.collection("Dailytask").add(taskItemModel.toJson()).whenComplete((){
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

    Future <TaskItemModel> getDetail(String title) async {
      final snapshot = await db.collection("Dailytask").where("Title", isEqualTo: title).get();
      final itemdata =  snapshot.docs.map((e) => TaskItemModel.fromSnapshot(e)).single;
      return itemdata;
    }
  }
  Future<List<TaskItemModel>> allitem() async{
      final Snapshot = await db.collection("Dailytask").get();
      final itemdata = Snapshot.docs.map((e) => TaskItemModel.fromSnapshot(e)).toList();
      return itemdata;
    }
   Future<void> updateTask(TaskItemModel taskItemModel) async{
      await db.collection("Dailytask").doc(taskItemModel.id).update(taskItemModel.toJson());
    }
    Future<void> deleteTask(TaskItemModel taskItemModel) async{
      await db.collection("Dailytask").doc(taskItemModel.id).delete();
    }
}
