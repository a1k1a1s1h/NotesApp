import 'package:Notes/model/noteData.dart';
import 'package:Notes/utils/database_helper.dart';
import 'package:flutter/material.dart';
import './note.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class Home extends StatefulWidget {

 
  @override
  _HomeState createState() => _HomeState();
}



class _HomeState extends State<Home> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<NoteData> noteList;
  int count = 0;
  

  navigateToNote(NoteData note,String appBarTitle) async{
     bool result = await Navigator.push(context, MaterialPageRoute(builder:(context){
            return Note(note,appBarTitle);
          }));
      if(result == true){
        updateListView();
      }
  }

  ListView getNoteList(){
    return ListView.builder(
      itemCount: count, 
      itemBuilder: (BuildContext context, int position){
        return Card(
          elevation: 0,
          //color: Colors.deepOrangeAccent,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: getPriorityColor(this.noteList[position].priority),
              child: getPriorityIcon(this.noteList[position].priority),
            ),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: (){
                _delete(context, noteList[position]);
              },
            ),
            title: Text(this.noteList[position].title),
            subtitle: Text(this.noteList[position].date),
            onTap: (){
              navigateToNote(this.noteList[position],"Edit Note");
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, NoteData note) async{
    int result = await databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showSnackBar(context,'Deleted');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1000),
      );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
          return Icon(Icons.star);
          break;
      case 2:
          return Icon(Icons.star_half);
          break;
      default:
          return Icon(Icons.star_half);
    }
  }

  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
          return Colors.deepPurple;
          break;
      case 2:
          return Colors.deepPurpleAccent;
          break;
      default:
          return Colors.deepPurpleAccent;
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<NoteData>> noteListFuture = databaseHelper.getNoteDbList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if(noteList == null){
      noteList = List<NoteData>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        elevation: 0,
      ),
      body: getNoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
           navigateToNote(NoteData('','',2),"Add Note");
        },
        child: Icon(Icons.add_circle),
        elevation: 7.0,
        tooltip: "Click to add a note",
        splashColor:Colors.deepPurple,
      ),
    );
  }
}