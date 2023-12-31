

import 'package:dailytask_app/AuthController.dart';
import 'package:dailytask_app/ItemCrud.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'Userdata.dart';  
class DailyTaskPage extends StatefulWidget {
  @override
  _DailyTaskPageState createState() => _DailyTaskPageState();
}

class _DailyTaskPageState extends State<DailyTaskPage> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool _isCompleted = false;

  bool _isEditing = false;
  int _editingIndex = -1;

  final itemrepo = Get.put(itemRepo());
  final auth = Get.put(AuthController());
  final controller = Get.put(user());
  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    if (_dateController.text.isNotEmpty) {
      selectedDate = DateTime.parse(_dateController.text);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        _dateController.text = picked.toIso8601String().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    
    Usermodel? userx = controller.userdata();
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Daily Tasks:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: 
              FutureBuilder<List<TaskItemModel>>(
                future: itemrepo.allitem(auth.firebaseUser.value!.uid),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }else if(snapshot.hasError){
                    print(snapshot.error);
                    return Text("Error1: ${snapshot.error}");
                  }else{
               return
               ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  TaskItemModel task = snapshot.data![index];
                  return 
                  TaskItem(
                    taskItem: snapshot.data![index],
                    onEdit: () {
                      _editTask(index,task,auth.firebaseUser.value!.uid);
                    },
                    onDelete: () {
                      _deleteTask(task,auth.firebaseUser.value!.uid);
                    },
                  );
                },
              );
                  }
                }
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskForm(context,null,auth.firebaseUser.value!.uid);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _editTask(int index, TaskItemModel taskedit,String uid) async {
    setState(() {
      _isEditing = true;
      _editingIndex = index;

      TaskItemModel task = taskedit;
      _titleController.text = task.taskTitle;
      _descriptionController.text = task.taskDescription;
      _dateController.text = task.taskDate;
      _isCompleted = task.isTaskCompleted;
    });
     String? id = taskedit.id;
    _showTaskForm(context,id,uid);
  }

  void _deleteTask(TaskItemModel idx,String uid) {
    setState(() {
      deletetask(idx,uid);
    });
  }
  Future<void> deletetask(TaskItemModel dailyTaskModel,String uid) async{
    await itemrepo.deleteTask(dailyTaskModel,uid);
  }

  void _addTask(String uid) {
    TaskItemModel newTask = TaskItemModel(
      taskTitle: _titleController.text,
      taskDescription: _descriptionController.text,
      taskDate: _dateController.text,
      isTaskCompleted: _isCompleted,
    );  

    setState(() {
      _addFirestore(newTask,uid);
    });
  }
   Future<void> _addFirestore(TaskItemModel dailyTaskModel,String uid) async {
    await itemrepo.CreateData(dailyTaskModel,uid);
    
  }
  void _updateTask(String id,String uid) {
    TaskItemModel updatedTask = TaskItemModel(
      id: id,
      taskTitle: _titleController.text,
      taskDescription: _descriptionController.text,
      taskDate: _dateController.text,
      isTaskCompleted: _isCompleted,
    );

    setState(() {
     updatefirestore(updatedTask,uid);
    });
    
    _clearForm();
  }
Future<void> updatefirestore(TaskItemModel dailyTaskModel,String uid) async{
      await itemrepo.updateTask(dailyTaskModel,uid);
    }
  void _clearForm() {
    setState(() {
      _isEditing = false;
      _editingIndex = -1;

      _titleController.text = '';
      _descriptionController.text = '';
      _dateController.text = '';
      _isCompleted = false;
    });
  }

 void _showTaskForm(BuildContext context, String? id, String uid) {
  showDialog(
    context: context,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;

      return 
        AlertDialog(
          title: Text(_isEditing ? 'Edit Task' : 'Add Task'),
          content: SingleChildScrollView(
            child:
          Container(
            height: screenHeight * 0.4,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Description'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _selectDate(context);
                          },
                          child: TextField(
                            controller: _dateController,
                            decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                            readOnly: true,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Completed:'),
                      Checkbox(
                        value: _isCompleted,
                        onChanged: (value) {
                          setState(() {
                            _isCompleted = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                if (_isEditing) {
                  _updateTask(id!, uid);
                } else {
                  _addTask(uid);
                }

                _clearForm();
              },
              child: Text(_isEditing ? 'Save Changes' : 'Add Task'),
            ),
          ],
      );
    },
  );
}



}

class TaskItem extends StatelessWidget {
  final TaskItemModel taskItem;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TaskItem({
    required this.taskItem,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(taskItem.taskTitle),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${taskItem.taskDescription}'),
            Text('Date: ${taskItem.taskDate}'),
            Text('Status: ${taskItem.isTaskCompleted ? 'Completed' : 'Not Completed'}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItemModel {
  final String? id;
  final String taskTitle;
  final String taskDescription;
  final String taskDate;
  final bool isTaskCompleted;

  TaskItemModel({
    this.id,
    required this.taskTitle,
    required this.taskDescription,
    required this.taskDate,
    required this.isTaskCompleted,
  });

  toJson(){
    return {
      "Title": taskTitle, "Description": taskDescription, "Date": taskDate, "status": isTaskCompleted};
    }

    factory TaskItemModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document){
      final data = document.data()!;
      return TaskItemModel(
        id: document.id,
        taskTitle: data["Title"],
        taskDescription: data["Description"],
        taskDate: data["Date"],
        isTaskCompleted: data["status"],
      );
    }
  }