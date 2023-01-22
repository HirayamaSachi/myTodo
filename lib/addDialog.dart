import 'package:flutter/material.dart';
import 'package:my_todo/crudTodo.dart';

Future<void> dialogBuilder(BuildContext context) {
  final myController = TextEditingController();
  return showDialog(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: Text('新規追加'),
          content: TextField(
            controller: myController,
            decoration: InputDecoration(labelText: '課題やる'),
            onSubmitted: ((value) {
              TodoManager.of(context).create(value);
              Navigator.pop(context);
            }),
          ),
        );
      }));
}
