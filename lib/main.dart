import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  List<String> todoLists = ["起きる", "寝る", "たべる"];
  String todo = "";

  displayDiaLog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text(todo),
              content: TextField(
                controller: textController,
                onChanged: (value) {
                  setState(() {
                    todo = value;
                  });
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: (todo.isEmpty)
                      ? null
                      : () {
                          setState(() {
                            Navigator.pop(context);
                            textController.clear();
                          });
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
        onPressed: () async {
          final result = displayDiaLog(context);
          setState(() {
          todo=result??todo;
          });
        },
        // child: Icon(Icons.add),
        child: Text(todo),
      ),
    );
  }
}

class showTodoList extends StatelessWidget {
  const showTodoList({
    Key? key,
    required this.todoLists,
  }) : super(key: key);

  final List<String> todoLists;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todoLists.length,
      itemBuilder: (BuildContext context, int index) {
        return Slidable(
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: '削除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {},
              )
            ],
            child: Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 60,
                child: Text(
                  todoLists[index],
                  style: TextStyle(fontSize: 15),
                )));
      },
    );
  }
}
