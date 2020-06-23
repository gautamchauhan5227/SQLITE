import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_lite/ContactKeeper/ContactModel.dart';

import 'ContactDetails.dart';
import 'Contact_Database_Helper.dart';

class contactList extends StatefulWidget {
  @override
  _contactListState createState() => _contactListState();
}

class _contactListState extends State<contactList> {
  ContactDatabaseHelper databaseHelper=ContactDatabaseHelper();
  List<Contact> contactList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Contact'),
        ),
        body: getNoteListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetailPage(Contact('','','','','','',1),'Add Contact');
            debugPrint("FAB");
          },
          tooltip: 'Add Contact',
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
              // leading: CircleAvatar(
              //   backgroundColor:getPriorityColor(this.contactList[position].priority),
              //   child: getPriorityIcon(this.noteList[position].priority),
              // ),
              title: Text(this.contactList[position].name),
              subtitle: Text(this.contactList[position].address),
              trailing: IconButton(
                icon: Icon(Icons.delete), 
                onPressed: (){
                  _delete(context, contactList[position]);
                }
              ),
              onTap: () {
                navigateToDetailPage(this.contactList[position],'Edit Note');
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
  void _delete(BuildContext context , Contact contact) async {
    int result= await databaseHelper.deleteContact(contact.id);
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


  void navigateToDetailPage(Contact contact,String title) async{
    bool result=await Navigator.push(context, MaterialPageRoute(builder: (context){
      return contactDetail(contact, title);
    }),);
    if(result==true){
      updateListview();
    }
  }

  void updateListview(){
    final Future<Database> dbFuture=databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Contact>> contactListFuture=databaseHelper.getContactList();
      contactListFuture.then((contactList){
        setState(() {
          this.contactList=contactList;
          this.count=contactList.length;
        });
      });
    });
  }
}
