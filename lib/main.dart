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
              children: [ShowTodoState()],
            ),
          ),
        ));
  }
}

class ShowTodoState extends StatefulWidget {
  const ShowTodoState({Key? key}) : super(key: key);

  @override
  State<ShowTodoState> createState() => _ShowTodoState();
}

class _ShowTodoState extends State<ShowTodoState> {
  @override
  List<Map<String, dynamic>> _todoList = [
    {'name': 'お勉強', 'completed': false},
    {'name': 'テスト', 'completed': false},
    {'name': '宿題', 'completed': false},
    {'name': '寝る', 'completed': false},
    {'name': '風呂', 'completed': false},
    {'name': '食事', 'completed': false},
    {'name': '掃除', 'completed': false},
  ];
  //  add
  void _isHandleAdd(String value) {
    setState(() {
      _todoList += [
        {'name': value, 'completed': false}
      ];
    });
  }

// del
  void _isHandleDel(int index) {
    setState(() {
      _todoList.remove(_todoList[index]);
    });
  }

// change
  void _isHandleUpdate(int index, String value) {
    setState(() {
      _todoList[index]['name'] = value;
    });
  }

// completed
  void _isHandleCmptoggle(int index) {
    setState(() {
      _todoList[index]['completed'] =
          _todoList[index]['completed'] ? false : true;
    });
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        showTodo(todoList: _todoList, onChanged: {
            'Del': _isHandleDel,
            'Cmptoggle': _isHandleCmptoggle,
            'Update': _isHandleUpdate
          }
          ),
          AddTodo(todoList: _todoList, onChanged: _isHandleAdd),
      ],
    );
  }
}

class showTodo extends StatelessWidget {
  const showTodo({required this.todoList, required this.onChanged, Key? key})
      : super(key: key);
  final List<Map<String, dynamic>> todoList;
  final Map<String, Function> onChanged;
  void _handleTap(keyName, value) {
    onChanged.forEach((key, funcName) {
      // 該当する関数をコールバックする
      if (keyName == key) {
        Function func = funcName;
        funcName(value);
      }
    });
  }

  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: todoList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [IconSlideAction(
              caption: '削除',
              icon: Icons.delete,
              color: Colors.red,
                // delete処理
              onTap: (){
                _handleTap('Del', index);
              },
            )],
            // child: CmpTodo(index),
            child:CheckboxListTile(
      title: Text(todoList[index]['name']),
      value: todoList[index]['completed'] ? true : false,
      // 完了処理
      onChanged: ((value) {
        _handleTap('Cmptoggle', index);
      }),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: IconButton(onPressed: (() {
        if(onChanged.containsKey("Update")){
          onChanged.forEach((key, value) {
            if(key=="Update"){
            void update(data){
              value(data);
            }
            // ページ遷移でupdate処理をかく
            // UpdateTodo(onChanged: update,todoList: todoList);
            }
          });
        }
        // UpdateTodo(todoList: todoList, onChanged: ),
      }), icon: Icon(Icons.create))
      ),
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
