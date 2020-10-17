import 'package:toDoApp/model/todo.dart';
import 'package:toDoApp/repositories/repository.dart';


class TodoService{
  Repository _repository; 

  TodoService() {
    _repository = Repository();
  }
  saveTodo(Todo todo) async{
    return await _repository.inserData('todos', todo.todoMap());
  }
  readTodo() async{
    return await _repository.readData('todos');
  }
  readTodoBy(category) async{
    return await _repository.readDataByColumnName('todos', 'category', category);
  }
}