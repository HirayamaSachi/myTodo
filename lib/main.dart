import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TodoManager(
            child: Builder(builder: (BuildContext innerContext) {
              final todo = TodoData.of(innerContext).todo;
              return ListView.builder(
                  itemCount: todo.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext innerContext, int index) {
                    return Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: [
                        IconSlideAction(
                          caption: '削除',
                          icon: Icons.delete,
                          color: Colors.red,
                          // delete処理
                          onTap: () {
                            TodoData.of(innerContext).data?.delete(index);
                          },
                        )
                      ],
                      // child: CmpTodo(index),
                      child: CheckboxListTile(
                          title: Text(todo[index]['name']),
                          value: todo[index]['completed'] ? true : false,
                          // 完了処理
                          onChanged: ((value) {
                            TodoData.of(innerContext).data?.completeToggle(index);
                          }),
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: IconButton(
                              onPressed: (() {}),
                              icon: Icon(
                                Icons.create,
                              ))),
                    );
                  });
            }),
          ),
        ],
      ),
    );
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
