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

  List<Map<String, dynamic>> todoLists = [];

  // setState処理
  void addTodo(todo) {
    setState(() {
      todoLists += [
        {'name': todo, 'completed': false}
      ];
    });
  }

// ダイアログ
  displayDiaLog({required BuildContext context, int? index, List? element}) {
    var todo = Todo("");
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
                    todo = Todo(value);
                  });
                },
              ),
              actions: [
                ElevatedButton(
                  onPressed: (todo == "")
                      ? null
                      : () {
                          if (index != null) {
                            updateTodo(element, index);
                          } else {
                            addTodo(textController.text);
                          }
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

  void updateTodo(List? element, int index) {
    element![index]['name'] = textController.text;
  }

// キーメッセージハンドラーの処理中に、次のアサーションがスローされました。
// setState（）はコンストラクターで呼び出されます：_MyHomePageState＃7B4FD（Lifecycle状態：作成、ウィジェットなし、
// いいえ
//マウント）
//これは、状態オブジェクトでsetState（）を呼び出したときに発生します。
//に挿入

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
          displayDiaLog(context: context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class showTodoList extends StatefulWidget {
  const showTodoList({
    Key? key,
    required this.todoLists,
  }) : super(key: key);

  final List<Map<String, dynamic>> todoLists;

  @override
  State<showTodoList> createState() => _showTodoListState();
}

class _showTodoListState extends State<showTodoList> {
  void deleteTodoList(todo) {
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
          child: new CheckboxListTile(
            value: widget.todoLists[index]['completed'],
            onChanged: ((value) {
              setState(() {
                widget.todoLists[index]['completed'] = value!;
              });
            }),
            title: Text(widget.todoLists[index]['name']),
            secondary: IconButton(
                onPressed: (() {
                  _MyHomePageState().displayDiaLog(
                      context: context, index: index, element: widget.todoLists);
                }),
                icon: Icon(Icons.create)),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        );
      },
    );
  }
}
