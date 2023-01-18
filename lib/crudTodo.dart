
import 'package:flutter/material.dart';

class TodoData extends InheritedWidget {
  final TodoManagerState? data;
  final List<Map<String, dynamic>> todo;
  final Widget child;

  const TodoData({
    key,
    this.data,
    required this.todo,
    required this.child,
  }) :assert(child!=null) ,super(key: key, child: child);

  static TodoData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TodoData>();
  }
   static TodoData of(BuildContext context) {
    final TodoData? result = maybeOf(context);
    assert(result != null, 'No TodoData found in context');
    print(result);
    return result!;
  }
  @override
  bool updateShouldNotify(TodoData oldWidget) => todo != oldWidget.todo;
}

class TodoManager extends StatefulWidget {
  const TodoManager({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  State<TodoManager> createState() => TodoManagerState();
}

class TodoManagerState extends State<TodoManager> {
  List<Map<String, dynamic>> todo = [
    {'name': 'お勉強', 'completed': false},
    {'name': 'テスト', 'completed': false},
    {'name': '宿題', 'completed': false},
    {'name': '寝る', 'completed': false},
    {'name': '風呂', 'completed': true},
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
    return TodoData(todo: todo, data: this,child: Builder(
      builder: (context) {
        return widget.child;
      }
    ));
  }
}
