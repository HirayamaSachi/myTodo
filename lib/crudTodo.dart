import 'package:flutter/material.dart';

class TodoData extends InheritedWidget {
  final _crudTodoState? data;
  final List<Map<String, dynamic>> todo;
  final Widget child;

  const TodoData({
    key,
    this.data,
    required this.todo,
    required this.child,
  }) :assert(child!=null) ,super(key: key, child: child);


  @override
  bool updateShouldNotify(TodoData oldWidget) => todo != oldWidget.todo;
}

class TodoManagerState extends StatefulWidget {
  const TodoManagerState({Key? key, required this.child}) : super(key: key);
   static _crudTodoState? of(
    BuildContext context, {
    required bool listen,
  }) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<TodoData>()?.data
          : (context.getElementForInheritedWidgetOfExactType<TodoData>()?.widget
              as TodoData).data;
  final Widget child;
  @override
  State<TodoManagerState> createState() => _crudTodoState();
}

class _crudTodoState extends State<TodoManagerState> {
  // List<Map<String, dynamic>> todo = [];
  List<Map<String, dynamic>> todo = [
    {'name': 'お勉強', 'completed': false},
    {'name': 'テスト', 'completed': false},
    {'name': '宿題', 'completed': false},
    {'name': '寝る', 'completed': false},
    {'name': '風呂', 'completed': false},
    {'name': '食事', 'completed': false},
    {'name': '掃除', 'completed': false},
  ];

  void create(String value) {
    setState(() {
      todo += [
        {'name': value, 'completed': false}
      ];
    });
  }

  void update(int index, String value) {
    setState(() {
      todo[index]['name'] = value;
    });
  }

  void completeToggle(int index) {
    setState(() {
      todo[index]['completed'] = todo[index]['completed'] ? false : true;
    });
  }

  void delete(int index) {
    setState(() {
      todo.remove(todo[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TodoData(todo: todo, data: this,child: widget.child);
  }
}
