import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject{
  @HiveField(0)
  String task;

  Todo(this.task);
}