import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todo_api/screens/add_page.dart';

import 'package:http/http.dart' as http;
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/utils/snackbar_helper.dart';
import 'package:todo_api/widget/todo_card.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
    bool isLoading=true;
    List items=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('todo List'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator(),),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(child:
            Text('No todo Items',
            style: Theme.of(context).textTheme.headline5,
            ),

            ),
            child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.all(9),
                itemBuilder: (context,index){
                  final item=items[index] as Map;
                  final id= item['_id'] as String;
              return TodoCard(
                  index: index,
                  item: item,
                  navigateEdit: navigateToEditPage,
                  deleteById: deleteById);
            }

            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage, label: Text('Add Todo'),),
    );
  }

  Future<void> navigateToAddPage() async{
    final route= MaterialPageRoute(
      builder: (context) => AddTodoPage(),

    );
   await Navigator.push(context, route);
   setState(() {
     isLoading=true;
   });
   fetchTodo();
  }
  Future<void> navigateToEditPage(Map item) async{
    final route= MaterialPageRoute(
      builder: (context) => AddTodoPage(todo:item),

    );
    await Navigator.push(context, route);
    setState(() {
      isLoading=true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async{
    //delete the item

    final isSuccess= await TodoService.deleteById(id);
    if(isSuccess){
    // remove item from list
      final filtered=items.where((element)=> element['_id']!=id).toList(); // used to refresh page without animation
      setState(() {
        items=filtered;
      });
    }else{
      //show error
      showErrorMessage(context, message:'deletion failed');

    }

  }

  Future<void> fetchTodo() async{
    final response=await TodoService.fetchTodo();
    if(response!= null){
      setState(() {
        items=response;
      });
    }else{
      showErrorMessage(context, message:'something went wrong');
    }
    setState((){
      isLoading=false;
    });

  }


}
