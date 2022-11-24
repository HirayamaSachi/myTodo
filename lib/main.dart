import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_todo/todoList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController textController = TextEditingController();
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
  List<String> todoLists = [];

  // setState処理
  void updateTodoList(todo) {
    setState(() {
      todoLists.add(todo);
    });
  }

// ダイアログ
  displayDiaLog(BuildContext context) {
    var todo=Todo("");
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('タスク追加'),
              content: TextField(
                controller: textController,
                onChanged: (value) {
                  setState(() {
                  todo=Todo(value);
                  });
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: (todo=="")
                      ? null
                      : () {
                          updateTodoList(textController.text);
                          textController.clear();
                          Navigator.pop(context);
                        },
                  child: Text('追加'),
                )
              ],
            );
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    // タスク項目表示処理
    return Scaffold(
      appBar: AppBar(
        title: Text('TodoApp'),
      ),
      body: Center(
        child: Container(
          child: showTodoList(todoLists: todoLists),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          displayDiaLog(context);
        },
        child: Icon(Icons.add),
        // child: Text(todo),
      ),
    );
  }
}

class showTodoList extends StatefulWidget {
  const showTodoList({
    Key? key,
    required this.todoLists,
  }) : super(key: key);

  final List<String> todoLists;

  @override
  State<showTodoList> createState() => _showTodoListState();
}

class _showTodoListState extends State<showTodoList> {

    void deleteTodoList(todo){
    setState(() {
    widget.todoLists.remove(todo);
    });
  }
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todoLists.length,
      itemBuilder: (BuildContext context, int index) {
        return Slidable(
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: '削除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  deleteTodoList(widget.todoLists[index]);
                },
              )
            ],
            child: Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                child: Text(
                  widget.todoLists[index],
                  style: TextStyle(fontSize: 15),
                )));
      },
    );
  }
}
