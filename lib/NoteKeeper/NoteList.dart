
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database_Helper.dart';
import 'Models.dart';
import 'NoteDetail.dart';

class noteList extends StatefulWidget {
  @override
  _noteListState createState() => _noteListState();
}

class _noteListState extends State<noteList> {
  DatabaseHelper databaseHelper=DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Note'),
        ),
        body: getNoteListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetailPage(Note('','',2),'Add Note');
            debugPrint("FAB");
          },
          tooltip: 'Add Note',
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:getPriorityColor(this.noteList[position].priority),
                child: getPriorityIcon(this.noteList[position].priority),
              ),
              title: Text(this.noteList[position].title),
              subtitle: Text(this.noteList[position].date),
              trailing: IconButton(
                icon: Icon(Icons.delete), 
                onPressed: (){
                  _delete(context, noteList[position]);
                }
              ),
              onTap: () {
                navigateToDetailPage(this.noteList[position],'Edit Note');
                debugPrint("Notes");
              },
            ),
          );
        },);
  }
  // return priority Color
  Color getPriorityColor(int priority){
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }
  }

   // return priority Icon
  Icon getPriorityIcon(int priority){
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  //delete notes
  void _delete(BuildContext context , Note note) async {
    int result= await databaseHelper.deleteNote(note.id);
    if(result!=0){
      _showSnackBar(context,'Note Deleted Sucessfully');
      updateListview();
    }
  }

  //display snackbar
  void _showSnackBar(BuildContext context ,String message){
    final snackBar=SnackBar(content: Text(message),);
    Scaffold.of(context).showSnackBar(snackBar);
  }


  void navigateToDetailPage(Note note,String title) async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context){
      return noteDetail(note, title);
    }),);
    if(result==true){
      updateListview();
    }
  }

  void updateListview(){
    final Future<Database> dbFuture=databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Note>> noteListFuture=databaseHelper.getNoteList();
      noteListFuture.then((noteList){
        setState(() {
          this.noteList=noteList;
          this.count=noteList.length;
        });
      });
    });
  }
}
