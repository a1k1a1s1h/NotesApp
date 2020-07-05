import 'package:flutter/material.dart';
import 'package:notes/model/noteData.dart';
import 'package:notes/utils/database_helper.dart';
import 'package:intl/intl.dart';

//import 'dart:async';

//import 'package:sqflite/sqlite_api.dart';

class Note extends StatefulWidget {

  final String appBarTitle;
  final NoteData note;
  Note(this.note,this.appBarTitle);
  @override
  _NoteState createState() => _NoteState(this.note,this.appBarTitle);
  
}

class _NoteState extends State<Note> {

  String appBarTitle;
  NoteData note;
  DatabaseHelper helper = DatabaseHelper();
  _NoteState(this.note,this.appBarTitle);
  static var _priority = ["High","Low"];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  moveToPreviousScreen(){
    Navigator.pop(context,true);
  }

  void updateTitle(){
    note.title = titleController.text;
  }
  void updateDescription(){
    note.description = descriptionController.text;
  }

  void priorityStringToInt(String value){
    switch(value){
      case 'High': note.priority = 1;
                   break;
      case 'Low' : note.priority = 2;
                   break;
    }
  }

  String getPriorityIntToString(int value){
    String priority;
    switch(value){
      case 1: priority = _priority[0];
              break;
      case 2: priority = _priority[1];
              break;     
    }
    return priority;
  }

  

  void _save() async{
    moveToPreviousScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id!=null){
      result = await helper.updateNote(note);
    } else{
      result = await helper.insertNote(note);
    }
    if(result != 0){
      //_showAlert("Status", "Note Saved");
    }else{
      _showAlert("Status", "Error Saving Note");
    }
  }

  void _delete() async{
    moveToPreviousScreen();
    if(note.id == null){
     //_showAlert("Status", "No Note Deleted");
     return;
    }
    int result = await helper.deleteNote(note.id);
    if(result !=0){
      //_showAlert("Status", "Note Deleted");
    }else{
      _showAlert("Status", "Error Deleting Note");
    }
  }

  void _showAlert(String title,String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_)=>alertDialog
    );
  }


  @override
  Widget build(BuildContext context) {
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
          onWillPop:() => moveToPreviousScreen(),
          child: Scaffold(
        appBar: AppBar(
          title:Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios), 
            onPressed: (){
              moveToPreviousScreen();
            }
          ),
        ),
        body: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  title:DropdownButton(
                    isExpanded: true,
                    iconEnabledColor: Colors.purple,
                    items: _priority.map((String dropDownStringItem){
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(
                          dropDownStringItem,
                        ),
                      );
                    }).toList(), 
                    onChanged: (value){
                      setState(() {
                        priorityStringToInt(value);
                      });
                    },
                    value: getPriorityIntToString(note.priority),
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                  child: TextField(
                  controller: titleController,
                  onChanged: (value){
                    setState(() {
                      updateTitle();
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                  child: TextField(
                  controller: descriptionController,
                  onChanged: (value){
                    setState(() {
                      updateDescription();
                    });
                  },
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                  children:<Widget>[
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        onPressed: (){
                          setState(() {
                            _save();
                          });
                        }, 
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      )
                    ),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: FlatButton(
                        padding: EdgeInsets.all(15),
                        onPressed: (){
                          setState(() {
                            _delete();
                          });
                        }, 
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      )
                    ),
                  ]
                ),
              )
            ],
          )
        ),
      ),
    );
    
  }
}