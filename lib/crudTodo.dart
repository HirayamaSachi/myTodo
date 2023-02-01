import 'package:flutter/material.dart';

class TodoData extends InheritedWidget {
  final TodoManagerState data;
  final List<TodoFactor> todo;
  final Widget child;

  const TodoData({
    key,
    required this.data,
    required this.todo,
    required this.child,
  })  : assert(child != null),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}

class TodoManager extends StatefulWidget {
  const TodoManager({Key? key, required this.child}) : super(key: key);
  final Widget child;

  static TodoManagerState of(BuildContext context, {bool rebuild = true}) {
    return rebuild
        ? context.dependOnInheritedWidgetOfExactType<TodoData>()!.data
        : (context.getElementForInheritedWidgetOfExactType<TodoData>()!.widget
                as TodoData)
            .data;
  }

  @override
  State<TodoManager> createState() => TodoManagerState();
}

class TodoManagerState extends State<TodoManager> {
  // List<Map<String, dynamic>> todo = [];
  List<TodoFactor> todo = [];

  void create(String value) {
    setState(() {
      todo += [TodoFactor(name: value)];
    });
  }

  void update(int index, String value) {
    setState(() {
      todo[index].name = value;
    });
  }

  void completeToggle(int index) {
    setState(() {
      todo[index].completed = todo[index].completed ? false : true;
    });
  }

  void delete(int index) {
    setState(() {
      todo.remove(todo[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TodoData(todo: todo, data: this, child: widget.child);
  }
}

class TodoFactor {
  TodoFactor({required this.name, this.completed = false});
  String name;
  bool completed;
}
