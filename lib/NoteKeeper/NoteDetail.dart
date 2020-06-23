
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'Database_Helper.dart';
import 'Models.dart';

class noteDetail extends StatefulWidget {
  final String appBartitle;
  final Note note;
  noteDetail(this.note,this.appBartitle);
  @override
  _noteDetailState createState() => _noteDetailState(this.note,this.appBartitle);
}

class _noteDetailState extends State<noteDetail> {
  static var _priorities = [
    'High',
    'Low',
  ];

  DatabaseHelper _databaseHelper=DatabaseHelper();
  String appBarTitle;
  Note note;
  List<Note> noteList;
  int count=0;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  _noteDetailState(this.note,this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    titleController.text=note.title;
    descriptionController.text=note.description;
    if (noteList == null) {
			noteList = List<Note>();
			updateListView();
		}
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.appBartitle),
        ),
        body: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListTile(
                    title: DropdownButton(
                      items: _priorities.map(
                        (String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        },
                      ).toList(),
                      onChanged: (valueSelctedByUser) {
                        setState(() {
                          debugPrint('Priorities');
                          updatePriorityAsInt(valueSelctedByUser);
                        });
                      },
                      value: getPriorityAsString(note.priority),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value){
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: descriptionController,
                    onChanged: (value){
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              _save();
                            });
                          },
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: RaisedButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            setState(() {
                              _delete();
                            });
                          },
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void moveLastPage(){
    Navigator.pop(context,true);
  }

  void updatePriorityAsInt(String value){
    switch(value){
      case  'High':
        note.priority=1;
        break;
      case  'Low':
        note.priority=2;
        break;
    }
  }

  String getPriorityAsString(int value){
    String priority;
    switch (value) {
      case 1:
        priority=_priorities[0];
        break;
      case 2:
        priority=_priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle(){
    note.title=titleController.text;
  }

  void updateDescription(){
    note.description=descriptionController.text;
  }
  

  // save data to database
  void _save()async{
    moveLastPage();
    note.date=DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id!=null){
      result=await _databaseHelper.updateNote(note);
    }else{
      result=await _databaseHelper.insertNote(note);
    }

    if(result!=0){
      _showAlertDialog('Status','Note Saved Successfully');
    }else{
      _showAlertDialog('Status','Problem Saving Note');
    }
  }

  void _showAlertDialog(String title,String message){
    AlertDialog alertDialog=AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context,
    builder: (_)=>alertDialog
    );
  }

  //delete 
  void _delete()async{
    moveLastPage();
    if(note.id==null){
      _showAlertDialog('Status', 'No Note Was Deleted');
      return;
    }
    int result=await _databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showAlertDialog('Status', 'Note Deleted Successfully');
    }else{
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void updateListView() {

		final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
		dbFuture.then((database) {

			Future<List<Note>> noteListFuture = _databaseHelper.getNoteList();
			noteListFuture.then((noteList) {
				setState(() {
				  this.noteList = noteList;
				  this.count = noteList.length;
				});
			});
		});
  }
}
