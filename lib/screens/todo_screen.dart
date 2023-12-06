import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:to_do/constans.dart';
import 'package:to_do/models/todo_model.dart';
import 'package:to_do/screens/home_screen.dart';

class TodoScreen extends StatelessWidget {
  TodoScreen(
      {super.key, required this.type, required this.index, required this.text});

  final String type;
  final int index;
  final String text;

  TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (type == 'update') {
      taskController.text = text;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        title: Text(
          type == 'add' ? 'Add Todo' : 'Update Todo',
          style: TextStyle(color: Colors.blueAccent),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(width: 2, color: Colors.grey)),
                    labelText: type == 'add'
                        ? 'Add Task content'
                        : 'Update Task content'),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (taskController.text != '') {
                    onButtonPressed(taskController.text);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ));
                  } else {
                    Get.defaultDialog(
                        title: 'پیغام',
                        middleText: 'لطفا ابتدا فیلد تسک را پر کنید');
                  }
                },
                child: Text(
                  type == 'add' ? 'Add' : 'Update',
                  style: const TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPinkColor),
                    fixedSize: MaterialStateProperty.all(Size(100, 40))),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onButtonPressed(String task) {
    if (type == 'add') {
      add(task);
    } else {
      update(task);
    }
    taskController.clear();
  }

  add(String task) async {
    var box = await Hive.openBox('todo');
    Todo todo = Todo(task);
    if (task != '') {
      await box.add(todo);
    }
  }

  update(String task) async {
    var box = await Hive.openBox('todo');
    Todo todo = Todo(task);
    await box.putAt(index, todo);
  }
}
