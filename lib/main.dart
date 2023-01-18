import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:my_todo/todoList.dart';
import 'crudTodo.dart';

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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Todo app',
        home: Scaffold(
          appBar: AppBar(title: const Text('Todo app')),
          body: SingleChildScrollView(
            child: Column(
              children: [
                TodoManagerState(
                  child: showTodo(),
                )
              ],
            ),
          ),
        ));
  }
}

class showTodo extends StatelessWidget {
  const showTodo();

  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: (TodoManagerState.of(context, listen: true) != null)
            ? TodoManagerState.of(context, listen: true)?.todo.length
            : 0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: '削除',
                icon: Icons.delete,
                color: Colors.red,
                // delete処理
                onTap: () {
                  (TodoManagerState.of(context, listen: true) != null)
                      ? TodoManagerState.of(context, listen: true)
                          ?.delete(index)
                      : null;
                },
              )
            ],
            // child: CmpTodo(index),
            child: CheckboxListTile(
                title: (TodoManagerState.of(context, listen: true) != null)
                    ? Text(TodoManagerState.of(context, listen: true)
                        ?.todo[index]['name'])
                    : Text(''),
                value: ((TodoManagerState.of(context, listen: true) != null)
                        ? TodoManagerState.of(context, listen: true)
                            ?.todo[index]['completed']
                        : false)
                    ? true
                    : false,
                // 完了処理
                onChanged: ((value) {
                  (TodoManagerState.of(context, listen: true) != null)
                      ? TodoManagerState.of(context, listen: true)
                          ?.completeToggle(index)
                      : null;
                }),
                controlAffinity: ListTileControlAffinity.leading,
                secondary: IconButton(
                    onPressed: (() {}),
                    icon: Icon(
                      Icons.create,
                    ))),
          );
        });
  }
}

class AddTodo extends StatelessWidget {
  const AddTodo({required this.todoList, required this.onChanged, Key? key})
      : super(key: key);

  final List<Map<String, dynamic>> todoList;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        // ダイアログを表示
        insertTodo(context);
      },
    );
  }

  // コールバック
  void _addTodo(value) {
    onChanged(value);
  }

  void insertTodo(BuildContext context) {
    String _text = "";
    // todoに入れるための一時的な変数
    void _handleText(String value) {
      _text = value;
    }

    showDialog(
        context: context,
        builder: ((context) {
          final TextEditingController _controller = TextEditingController();
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: Text('タスク追加'),
              content: TextField(
                controller: _controller,
                onChanged: _handleText,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    (_text != "") ? _addTodo(_text) : null;
                    // ダイアログを抜ける
                    Navigator.pop(context);
                  },
                  child: Text('追加'),
                )
              ],
            );
          });
        }));
  }
}
