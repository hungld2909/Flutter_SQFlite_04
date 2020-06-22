import 'package:CWC_Flutter/helpers/drawer_navigation.dart';
import 'package:CWC_Flutter/models/todo.dart';
import 'package:CWC_Flutter/screen/todo_page.dart';
import 'package:CWC_Flutter/services/todo_service.dart';
import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {


  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TodoService _todoService;
  List<Todo> _todoList = List<Todo>();

  @override
  void initState() { 
    super.initState();
    getAllTodos();
  }
  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>();

    var todos = await _todoService.readTodos();

    todos.forEach((todo){
      setState(() {
        var model = Todo();
        model.id = todo['id'];
        model.title = todo['title'];
        model.description = todo['description'];
        model.category = todo['category'];
        model.todoDate = todo['todoDate'];
        model.isFinished = todo['isFinished'];
        _todoList.add(model);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todolist sqflite"),
      ),
      drawer: DrawerNavigaton(
        
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.only(top: 8.0,left: 8.0,right: 8.0),
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_todoList[index].title ?? 'No Hope'),
                ],
              ),
              subtitle: Text(_todoList[index].category ?? 'No Category'),
              trailing: Text(_todoList[index].todoDate ?? 'No Date'),
              ),
            ),
          );
        }
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoScreen()));
        },
        child: Icon(Icons.add),
        ),
    );
  }
}