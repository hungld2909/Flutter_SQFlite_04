import 'package:CWC_Flutter/screen/category_page.dart';
import 'package:CWC_Flutter/screen/home_page.dart';
import 'package:CWC_Flutter/screen/todos_by_category.dart';
import 'package:CWC_Flutter/services/category_service.dart';
import 'package:flutter/material.dart';

class DrawerNavigaton extends StatefulWidget {
  @override
  _DrawerNavigatonState createState() => _DrawerNavigatonState();
}

class _DrawerNavigatonState extends State<DrawerNavigaton> {
  List<Widget> _categoryList = List<Widget>();
  CategoryService _categoryService = CategoryService();



  @override
  void initState() { 
    super.initState();
    getAllCategories();
  }

  getAllCategories()async{
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        _categoryList.add(InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> TodosByCategory(category: category['name'],))),
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
                backgroundImage: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRlqHd-Q2C_f2kCJBmCsORjdqCaYlPN79LDZuBFbwfuIHT9CQcN&usqp=CAU'),
              ),
              accountName: Text('HungLD'),
              accountEmail: Text('Hungldgch29091996@gmail.com'),
              decoration: BoxDecoration(
                color: Colors.blue
              ),
            ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen() )),
              ),
                ListTile(
                leading: Icon(Icons.view_list),
                title: Text('Categories'),
                onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriesScreen())),
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
