import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_api/services/todo_service.dart';
import 'package:todo_api/utils/snackbar_helper.dart';
class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
  this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  bool isEdit=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final todo=widget.todo;   //here prefilling of value is done
    if(todo!=null){
      isEdit=true;
      final title=todo['title'];
      final description=todo['description'];
      titleController.text= title;
      descriptionController.text=description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
            isEdit ?'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller:titleController,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: isEdit? updateData: submitData,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                  isEdit? 'Update' : 'Submit'),
            ),),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    final todo=widget.todo;
    if(todo==null){
      print('you cannot call updated without tdo data');
      return;
    }
    final id= todo['_id'];

    //submit updated data to server
    final isSuccess=await TodoService.updatetodo(id, body);
    // show sucess or fail mesage based on status
    if(isSuccess){
      showSuccessMessage(context, message:'Update Success');

    }else{

      showErrorMessage(context, message:'Update Failed');
      print('Error creation failed');


    }
  }

  Future<void> submitData() async{
    //get the data from form
       // body( used to get data) is made a function which is defined in last of this page

    // submit data to server

    final isSuccess=await TodoService.addtodo(body);


     // show sucess or fail mesage based on status
    if(isSuccess){
      showSuccessMessage(context, message:'Creation Success');
      titleController.text='';
      descriptionController.text='';
      // print('Success');
      // print(response.body);

    }else{

      showErrorMessage(context, message:'Creation failed');
      print('Error creation failed');
     // print(response.body);
    }
  }
 Map get body{
   //get the data from form
   final title= titleController.text;
   final description= descriptionController.text;
   return {
     'title': title,
     'description': description,
     'is_completed': false,
   };
 }

}
