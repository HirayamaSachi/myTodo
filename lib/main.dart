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
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(tabs: [
                Tab(
                  text: 'All',
                ),
                Tab(
                  text: 'Active',
                ),
                Tab(
                  text: 'Completed',
                ),
              ]),
            ),
            body: const TodoManager(
                child: TabBarView(children: [
              ShowTodo(
                filterType: 'All',
              ),
              ShowTodo(
                filterType: 'Active',
              ),
              ShowTodo(
                filterType: 'Completed',
              ),
            ])),
          ),
        ),
      ),
    );
  }
}

class ShowTodo extends StatelessWidget {
  const ShowTodo({String this.filterType = 'All', Key? key}) : super(key: key);
  final filterType;
  @override
  Widget build(BuildContext context) {
    var todo = TodoManager.of(context).todo;
    switch (filterType) {
      case 'Active':
        todo = todo.where((element) => element.completed == false).toList();
        break;
      case 'Completed':
        todo = todo.where((element) => element.completed == true).toList();
        break;
      case 'All':
        break;
      default:
        print('Error!:filterTypeの値が不正です');
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
