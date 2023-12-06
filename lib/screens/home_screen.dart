import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do/constans.dart';
import 'package:to_do/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        leading: const Icon(
          Icons.menu,
          color: Colors.blueAccent,
        ),
        actions: [
          IconButton(
              onPressed: () {
                AwesomeDialog(
                    context: context,
                    title: 'Search',
                    animType: AnimType.scale,
                    body: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: searchController,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                AwesomeDialog(
                                    context: context,
                                    body: FutureBuilder(
                                      future: Hive.openBox('todo'),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData &&
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          return todoSearchList(
                                              searchController.text);
                                        } else {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                      },
                                    )).show();
                                searchController.clear();
                              },
                              child: Text('Search')),
                        ],
                      ),
                    )).show();
              },
              icon: Icon(
                Icons.search,
                color: Colors.blueAccent,
              ))
        ],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          myNavigator(context, 'add', -1, '');
        },
        backgroundColor: kPinkColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What's up!, Benjamin",
                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Today's task",
                style: TextStyle(fontSize: 20, color: Colors.blueAccent),
              ),
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: Hive.openBox('todo'),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return todoList();
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget todoList() {
    Box todobox = Hive.box('todo');
    return ValueListenableBuilder(
      valueListenable: todobox.listenable(),
      builder: (context, Box box, child) {
        if (box.values.isEmpty) {
          return Text(
            'No data!',
            style: TextStyle(fontSize: 20),
          );
        } else {
          return SizedBox(
            height: 500,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: todobox.length,
              itemBuilder: (context, index) {
                final todo = box.getAt(index);
                return GestureDetector(
                  onTap: () {
                    myNavigator(context, 'update', index, todo.task);
                  },
                  child: Card(
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11)),
                    color: kDarkBlueColor,
                    child: ListTile(
                      leading: Icon(Icons.check),
                      title: Text(
                        todo.task,
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          remove(index);
                        },
                        icon: Icon(Icons.delete),
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  Widget todoSearchList(String searchText) {
    Box todobox = Hive.box('todo');

    return ValueListenableBuilder(
      valueListenable: todobox.listenable(),
      builder: (context, Box box, child) {
        List<dynamic> originalList = box.values.toList();
        List<dynamic> filteredTodos = originalList
            .where((todo) => todo.task.contains(searchText))
            .toList();

        if (filteredTodos.isEmpty) {
          return Text(
            'No matching data!',
            style: TextStyle(fontSize: 20),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: filteredTodos.length,
            itemBuilder: (context, index) {
              final todo = filteredTodos[index];
              return GestureDetector(
                onTap: () {
                  myNavigator(context, 'update', index, todo.task);
                },
                child: Card(
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  color: kDarkBlueColor,
                  child: ListTile(
                    leading: Icon(Icons.check),
                    title: Text(
                      todo.task,
                      style: TextStyle(fontSize: 18),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        remove(index);
                      },
                      icon: Icon(Icons.delete),
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  myNavigator(context, String type, int index, String text) {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return TodoScreen(
          type: type,
          index: index,
          text: text,
        );
      },
    ));
  }

  void remove(index) {
    Box box = Hive.box('todo');
    box.deleteAt(index);
  }

  void search() {}
}
