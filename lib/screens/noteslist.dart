import 'package:flutter/material.dart';
import './note.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int count = 0;
  

  navigateToNote(String appBarTitle){
     Navigator.push(context, MaterialPageRoute(builder:(context){
            return Note(appBarTitle);
          }));
  }

  ListView getNoteList(){
    return ListView.builder(
      itemCount: count, 
      itemBuilder: (BuildContext context, int position){
        return Card(
          elevation: 2,
          color: Colors.blueGrey,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.cyanAccent,
              child: Icon(
                Icons.star,
                color: Colors.white,
              ),
            ),
            trailing: Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            title: Text("Title"),
            subtitle: Text("Subtitle"),
            onTap: (){
              navigateToNote("Edit Note");
            },
          ),
        );
      },
      );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
        elevation: 0,
      ),
      body: getNoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
           navigateToNote("Add Note");
        },
        child: Icon(Icons.add_circle),
        elevation: 7.0,
        tooltip: "Click to add a note",
        splashColor:Colors.deepPurple,
      ),
    );
  }
}