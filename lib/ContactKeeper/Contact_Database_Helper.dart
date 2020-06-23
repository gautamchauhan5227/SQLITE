import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'ContactModel.dart';
class ContactDatabaseHelper{
  static ContactDatabaseHelper _contactdatabaseHelper;//singleton DatabasHelper
  static Database _database;

  String contactTable='contact_table';
  String colId='id';
  String colName='name';
  String colPhone='phone';
  String colEmail='email';
  String colWhatsapp='whatsapp';
  String colAddress='address';
  String colBirthday='dob';
  String colRelation='relation';


  ContactDatabaseHelper._createInstance();//Name constructor to create instance of DatabaseHelper

  //factory keyword use to constructor class allow to return value 
  factory ContactDatabaseHelper(){
    if(_contactdatabaseHelper==null){
      _contactdatabaseHelper=ContactDatabaseHelper._createInstance();//this is excuted only once singleton object
    }   
    return _contactdatabaseHelper;
  }

  Future<Database> get database async{
    if(_database==null){
      _database=await initializeDatabase();
    }
    return _database;
  }


  Future<Database> initializeDatabase()async{
    Directory directorys= await getApplicationDocumentsDirectory();
    String paths=directorys.path+'contact.db';

    //open and create database at given path
    var contactDatabase = await openDatabase(paths,version:1,onCreate: _createDb);
    return contactDatabase;
  }

  void _createDb(Database dbs,int newVersion)async{
    await dbs.execute('CREATE TABLE $contactTable($colId INTEGER PRIMARY KEY AUTOINCREMENT,$colName TEXT,$colPhone TEXT'
    '$colEmail TEXT ,$colWhatsapp TEXT ,$colAddress TEXT ,$colBirthday TEXT,$colRelation INTEGER)');
  }


  //fetch operation
  Future<List<Map<String,dynamic>>>getContactMapList()async{
    Database db= await this.database;
    //var result=await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result= await db.query(contactTable);
    return result;
  }

  //insert operation
  Future<int> insertContact(Contact contact)async{
    Database dbs= await this.database;
    var result= await dbs.insert(contactTable,contact.toMap(),);
    return result;
  }

  //update operation
  Future<int> updateContact(Contact contact)async{
    Database db= await this.database;
    var result= await db.update(contactTable,contact.toMap(),where:'$colId=?',whereArgs: [contact.id]);
    return result;
  }

  //delete operation
  Future<int> deleteContact(int id)async{
    Database db= await this.database;
    int result= await db.rawDelete('DELETE FROM $contactTable WHERE $colId = $id');
    return result;
  }

  //Get number of notes in  database 
  Future<int> getCountContact()async{
    Database db= await this.database;
    List<Map<String , dynamic>> x=await db.rawQuery('SELECT COUNT (*) from $contactTable');
    int result=Sqflite.firstIntValue(x);
    return result;
  }

  //get the 'map list' [List<Map>] and convert it to Note List [List<Note>]
  Future<List<Contact>> getContactList() async{
    var contactMapList=await getContactMapList();
    int count=contactMapList.length;

    List<Contact> contactList=List<Contact>();
    for(int i=0;i<count;i++){
      contactList.add(Contact.fromMapObject(contactMapList[i]),);
    }
    return contactList;
  }

}