import 'package:flutter/material.dart';
import 'package:toDoApp/screen/homeScreen.dart';
import 'package:toDoApp/screen/categoryScreen.dart';
import 'package:toDoApp/screen/todoByCategoryScreen.dart';
import 'package:toDoApp/service/categoryService.dart';

class DrawerNavigation extends StatefulWidget {
  // DrawerNavigation({Key key}) : super(key: key); 

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
    List<Widget> _categoryList = List<Widget>();
  CategoryService _categoryService = CategoryService();

  @override
  void initState() { 
    super.initState();
    getAllCategory();
    
  }

  getAllCategory() async{
    var category = await _categoryService.readCategories();
    category.forEach((category) {
      setState((){
        _categoryList.add(InkWell(
          onTap: ()=>Navigator.push(context, new MaterialPageRoute(builder: (context)=>new TodosbyCategory(category: category['name'],))),
          child: ListTile(
          title: Text(category['name']),
          ),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://cdn.pixabay.com/photo/2017/06/13/12/53/profile-2398782_960_720.png'
                ),
              ),
              accountName: Text('Muhamad Biki Hamzah'), 
              accountEmail: Text('admin@gmail.com'),
              decoration: BoxDecoration(color: Colors.lightBlue),
            ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen())),
          ),
          ListTile(
            leading: Icon(Icons.view_list),
            title: Text('Categories'),
            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryScreen())),
          ),
          Divider(),
          Column(
            children: _categoryList,
          ),
          ],
        ),
      ),
    );
  }
}