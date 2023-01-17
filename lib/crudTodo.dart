import 'package:flutter/material.dart';

class CrudTodo extends InheritedWidget {
  const CrudTodo({
    key,
    required this.todo,
    required this.child,
  }) : super(key: key, child: child);

  final List<String> todo;
  final Widget child;

  static CrudTodo? of(
    BuildContext context, {
    required bool listen,
  }) =>
      listen
          ? context.dependOnInheritedWidgetOfExactType<CrudTodo>()
          : context.getElementForInheritedWidgetOfExactType<CrudTodo>()?.widget as CrudTodo;

  @override
  bool updateShouldNotify(CrudTodo oldWidget) => todo != oldWidget.todo;
}
