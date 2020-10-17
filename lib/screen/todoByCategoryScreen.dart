import 'package:flutter/material.dart';
import 'package:toDoApp/model/todo.dart';
import 'package:toDoApp/service/todoService.dart';

class TodosbyCategory extends StatefulWidget {
  // TodosbyCategory({Key key}) : super(key: key);
  final String category;
  TodosbyCategory({this.category});

  @override
  _TodosbyCategoryState createState() => _TodosbyCategoryState();
}

class _TodosbyCategoryState extends State<TodosbyCategory> {
  List<Todo> _todoList = List<Todo>();
  TodoService _todoService = TodoService();

  @override
  void initState() { 
    super.initState();
    getTodosbyCategory();
  }

  getTodosbyCategory() async{
    var todos = await _todoService.readTodoBy(this.widget.category);
    todos.forEach((todo) {
      setState(() {
        var model = Todo();
        model.title = todo['title'];
        model.description = todo['description'];
        model.todoDate = todo['todoDate'];
        _todoList.add(model);
      });
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.category),
      ),
      body: Column(
        children: <Widget>[
          Expanded(child: ListView.builder( 
            itemCount:_todoList.length, 
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 8, 
                  child: ListTile(
                    title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_todoList[index].title ?? 'No Title'),
                    ] ,
                  ),
                  subtitle: Text(_todoList[index].description ?? 'No Description'),
                  trailing: Text(_todoList[index].todoDate ?? 'No Date'),
                  ),
                ),
              );
            })
          )
        ],
      ),
    );
  }
}