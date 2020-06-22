import 'package:CWC_Flutter/models/category.dart';
import 'package:CWC_Flutter/screen/home_page.dart';
import 'package:CWC_Flutter/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categoryList = List<Category>();
  var category;

  var _category = Category();
  var _categoryService = CategoryService();

  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  getAllCategories() async {
    _categoryList = List<Category>(); // nếu k thêm list này nó sẽ gọi lại list cũ + với list mới.
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.id = category['id'];
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        _categoryList.add(categoryModel);
      });
    });
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.blue,
                onPressed: () async {
                  //todo: Code
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  var result = await _categoryService.saveCategory(_category);
                  if (result > 0) {
                    print(result);
                    Navigator.pop(context);
                    getAllCategories();
                  }
                },
                child: Text('Save'),
              ),
              FlatButton(
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
            title: Text('Categories Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a category', labelText: 'Category'),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editCategory(BuildContext context, categoryId) async {
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editCategoryNameController.text = category[0]['name'] ?? 'No Name';
      _editCategoryDescriptionController.text =
          category[0]['description'] ?? 'No Description';
    });
    _editFormDialog(context);
  }

  _editFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.green,
                onPressed: () async {
                  //todo: Code
                  _category.id = category[0]['id'];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;
                  var result = await _categoryService.updateCategory(_category);
                  if (result > 0) {
                    print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(Text('Updated Success'));
                  }
                },
                child: Text('Update'),
              ),
              FlatButton(
                color: Colors.red,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
            title: Text('Edit Categories Form'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editCategoryNameController,
                    decoration: InputDecoration(
                        hintText: 'Write a category', labelText: 'Category'),
                  ),
                  TextField(
                    controller: _editCategoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: 'Write a description',
                        labelText: 'Description'),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, categoryId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () async {
                  //todo: Code
                  // _category.id = category[0]['id'];
                  var result =
                      await _categoryService.deleteCategory(categoryId);
                  if (result > 0) {
                    print(result);
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackBar(Text('Delete Success'));
                  }
                },
                child: Text('Delete'),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
            title: Text('Are you sure you want to delete this?'),
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
        leading: RaisedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          elevation: 0.0,
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: Colors.blue,
        ),
        title: Text('Category'),
      ),
      body: ListView.builder(
        itemCount: _categoryList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8.0,
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editCategory(context, _categoryList[index].id);
                    }),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_categoryList[index].name),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _deleteFormDialog(context, _categoryList[index].id);
                        })
                  ],
                ),
                // subtitle: Text(_categoryList[index].description),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //todo: code
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
