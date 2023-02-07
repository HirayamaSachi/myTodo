import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'crudTodo.dart';
import 'addDialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return TodoManager(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(),
          body: const TodoManager(child: ShowTodo()),
        ),
      ),
    );
  }
}

class ShowTodo extends StatelessWidget {
  const ShowTodo({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final todo = TodoManager.of(context).todo;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          TextButton(child: const Text('All'), onPressed: (() {
            // TODO: filterかける
          })),
          TextButton(child: const Text('Active'), onPressed: (() {
            // TODO: filterかける
          })),
          TextButton(child: const Text('Completed'), onPressed: (() {
            // TODO: filterかける
          }))
        ],),
        Expanded(
          child: ListView.builder(
              itemCount: todo.length,
              shrinkWrap: true,
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
                        TodoManager.of(context, rebuild: false).delete(index);
                      },
                    )
                  ],
                  // child: CmpTodo(index),
                  child: CheckboxListTile(
                      title: Text(todo[index].name),
                      value: todo[index].completed ? true : false,
                      // 完了処理
                      onChanged: ((value) {
                        TodoManager.of(context, rebuild: false)
                            .completeToggle(index);
                      }),
                      controlAffinity: ListTileControlAffinity.leading,
                      secondary: IconButton(
                          onPressed: (() async{
                            var result= await dialogBuilder(context, isNew: false);
                            if(result == null || result == ""){return;}
                            TodoManager.of(context).update(index, result);
                          }),
                          icon: const Icon(
                            Icons.create,
                          ))),
                );
              }),
        ),
        FloatingActionButton(
          onPressed: (() async {
            var result = await dialogBuilder(context, isNew: true);
            if(result == null || result == ""){return;}
            TodoManager.of(context, rebuild: false).create(result.toString());
          }),
          child: Icon(Icons.add),
        )
      ],
    );
  }
}
