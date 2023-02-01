import 'package:flutter/material.dart';
import 'package:my_todo/crudTodo.dart';

Future dialogBuilder(BuildContext context,{ bool isNew =false}) {
  final myController = TextEditingController();
  return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: (isNew) ? Text('新規追加') : Text('更新'),
          content: TextField(
            controller: myController,
            decoration: InputDecoration(labelText: '課題やる'),
            onSubmitted: ((value) {
              Navigator.pop(context,value);
            }),
          ),
        );
      }));
}
