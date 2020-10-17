import 'package:flutter/material.dart';
import 'package:toDoApp/model/todo.dart';
import 'package:toDoApp/screen/homeScreen.dart';
import 'package:toDoApp/service/categoryService.dart';
import 'package:intl/intl.dart';
import 'package:toDoApp/service/todoService.dart';

class TodoScreen extends StatefulWidget {
  // TodoScreen({Key key}) : super(key: key);

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController  = TextEditingController();
  var _todoDescriptionController  = TextEditingController();

  var _todoDateController = TextEditingController();

  var _categories = List<DropdownMenuItem>();

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  var _selectedValues;

  @override
  void initState(){
    super.initState();
    _loadCategories();
  }

  _loadCategories() async{
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(
          DropdownMenuItem(
            child: Text(category['name']), 
            value: category['name'],
          )
        );
      });
    });
  }

  DateTime _dateTime = DateTime.now();

  _selectedTodoDate(BuildContext context) async{
    var _pickedDate = await showDatePicker(
      context: context, 
      initialDate: _dateTime, 
      firstDate: DateTime(2000), 
      lastDate: DateTime(2100)
    );

    if(_pickedDate != null) {
      setState(() {
        _dateTime = _pickedDate; 
        _todoDateController.text = DateFormat('dd-MM-yyyy').format(_pickedDate);
      });
    }
  }

  _showSnackBar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title : Text('Create Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller:  _todoTitleController, 
              decoration: InputDecoration(
                labelText: 'Title', 
                hintText: 'Write Todo Title'
              )
            ),
            TextField(
              controller:  _todoDescriptionController, 
              decoration: InputDecoration(
                labelText: 'Description', 
                hintText: 'Write Todo Description'
              )
            ),
            TextField(
              controller:  _todoDateController, 
              decoration: InputDecoration(
                labelText: 'Date', 
                hintText: 'Pick a Date',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectedTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                )
              )
            ),
            DropdownButtonFormField(
              items: _categories,
              value: _selectedValues, 
              hint: Text('Category'),
              onChanged: (value) {
                setState(() {
                  _selectedValues = value;
                });
              }
            ),
            SizedBox(
              height: 20, 
            ),
            RaisedButton(
              onPressed: () async{
                var todoObject = Todo();
                todoObject.title = _todoTitleController.text;
                todoObject.description = _todoDescriptionController.text;
                todoObject.category = _selectedValues.toString();
                todoObject.todoDate = _todoDateController.text;
                todoObject.isFinished = 0;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                if(result>0) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen()));
                  _showSnackBar(Text('Success Added Todo'));
                }
              },
              color: Colors.blue,
              child: Text('Save', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}