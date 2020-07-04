import 'package:flutter/material.dart';

class Note extends StatefulWidget {

  String appBarTitle;
  Note(this.appBarTitle);
  @override
  _NoteState createState() => _NoteState(this.appBarTitle);
  
}

class _NoteState extends State<Note> {

  String appBarTitle;
  _NoteState(this.appBarTitle);
  static var _priority = ["High","Low"];
  var _selected = _priority[0];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  moveToPreviousScreen(){
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
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
          actions:<Widget>[
            Padding(
              padding: EdgeInsets.only(right:10),
              child: IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ), 
                onPressed: (){
                  
                },
                splashColor: Colors.purpleAccent,
                )
              ),
          ],
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
                        _selected = value;
                      });
                    },
                    value: _selected,
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                  child: TextField(
                  controller: titleController,
                  onChanged: (value){
                    setState(() {
                      debugPrint("$value");
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
                      debugPrint("$value");
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