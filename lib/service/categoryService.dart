import 'package:toDoApp/repositories/repository.dart';
import 'package:toDoApp/model/category.dart';

class CategoryService{
  Repository _repository;

  CategoryService(){
    _repository = Repository();
  }


  saveCategory(Category category) async{
    return await _repository.inserData('categories', category.categoryMap());
  }

  readCategories() async{
    return await _repository.readData('categories');
  }

  readCategoryById(categoryId) async{
    return await _repository.readDataById('categories', categoryId);
  }

  updateCategory(Category category) async{
    return await _repository.updateData('categories', category.categoryMap());
}

  deleteCategory(categoryId) async{
    return await _repository.deleteData('categories', categoryId);
  }
}