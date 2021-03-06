import 'package:flutter/material.dart';
import 'package:toDoApp/screen/homeScreen.dart';
import 'package:toDoApp/model/category.dart';
import 'package:toDoApp/service/categoryService.dart';

class CategoryScreen extends StatefulWidget {
  // CategoryScreen({Key key}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();
  var _category = Category();
  var _categoryService = CategoryService();
  var category;

  List<Category> _categoryList = List<Category>();


  @override
  void initState(){
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async{
    _categoryList = List<Category>();
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _editCategory(BuildContext context, categoryId) async{
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text = category[0]['description'] ?? 'No Description';
    });

    _editFormDialog(context);
  }


  _showFormDialog(BuildContext context) {
    return showDialog(context: context, barrierDismissible: true, builder: (param) {
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.red,
            onPressed: ()=>Navigator.pop(context), 
            child: Text('Cancel')
          ),
          FlatButton(
            color: Colors.blue,
            onPressed: () async{
              _category.name = _categoryNameController.text;
              _category.description = _categoryDescriptionController.text;
              var result = await _categoryService.saveCategory(_category);

              if(result>0) {
                _showSuccessSnackBar(Text('Added'));
                Navigator.pop(context);
                getAllCategories();
              }
            }, 
            child: Text('Save')
          )
        ],
        title: Text('Category Form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              TextField(
                controller: _categoryNameController,
                decoration: InputDecoration(
                  hintText: 'Write Category',
                  labelText: 'Category'
                )
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Write Description',
                  labelText: 'Description'
                )
              ),
            ]
          ),
        ),
      );
    });
  }

  _editFormDialog(BuildContext context) {
    return showDialog(context: context, barrierDismissible: true, builder: (param) {
      return AlertDialog(
        actions: <Widget>[
          FlatButton(
            color: Colors.red,
            onPressed: ()=>Navigator.pop(context), 
            child: Text('Cancel')
          ),
          FlatButton(
            color: Colors.blue,
            onPressed: () async{
              _category.id = category[0]['id'];
              _category.name = _editCategoryNameController.text;
              _category.description = _editCategoryDescriptionController.text;

              var result = await _categoryService.updateCategory(_category);
              if (result > 0 ) {
                print(result);
                Navigator.pop(context);
                getAllCategories();
                _showSuccessSnackBar(Text('Updated'));
              }
            }, 
            child: Text('Update')
          )
        ],
        title: Text('Edit Category Form'),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget> [
              TextField(
                controller: _editCategoryNameController,
                decoration: InputDecoration(
                  hintText: 'Write Category',
                  labelText: 'Category'
                )
              ),
              TextField(
                controller: _editCategoryDescriptionController,
                decoration: InputDecoration(
                  hintText: 'Write Description',
                  labelText: 'Description'
                )
              ),
            ]
          ),
        ),
      );
    });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
      return showDialog(context: context, barrierDismissible: true, builder: (param) {
        return AlertDialog(
          actions: <Widget>[
            FlatButton(
              color: Colors.green,
              onPressed: ()=>Navigator.pop(context), 
              child: Text('Cancel')
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () async{
                var result = await _categoryService.deleteCategory(categoryId);
                if (result > 0 ) {
                  print(result);
                  Navigator.pop(context);
                  getAllCategories();
                  _showSuccessSnackBar(Text('Deleted Succes'));
                }
              }, 
              child: Text('Delete')
            )
          ],
          title: Text('Are You Sure Delete Category?'),
        );
      });
  }



  _showSuccessSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Categories'), 
        leading: RaisedButton(
          onPressed: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen())), 
          elevation: 0.0,
          child: Icon(Icons.arrow_back, color: Colors.white,),
          color:  Colors.blue,
        ),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left:16.0, right: 16.0, ),
            child: Card(
              elevation: 8.0,
              child: ListTile(
                leading: IconButton(icon: Icon(Icons.edit), onPressed: (){
                  _editCategory(context, _categoryList[index].id);
                }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget> [
                    Text(_categoryList[index].name), 
                    IconButton(
                      icon: Icon(Icons.delete), 
                      color: Colors.red, 
                      onPressed: (){
                        _deleteFormDialog(context, _categoryList[index].id);
                      }
                    )
                  ],
                ),
              ),
            ),
          );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}