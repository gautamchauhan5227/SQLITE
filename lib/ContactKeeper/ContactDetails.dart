import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sql_lite/ContactKeeper/ContactModel.dart';

import 'Contact_Database_Helper.dart';

class contactDetail extends StatefulWidget {
  final String appBartitle;
  final Contact contact;
  contactDetail(this.contact, this.appBartitle);
  @override
  _contactDetailState createState() =>
      _contactDetailState(this.contact, this.appBartitle);
}

class _contactDetailState extends State<contactDetail> {
  static var _priorities = [
    'Family',
    'Friend',
    'Colleagues',
    'Work'
  ];

  ContactDatabaseHelper _databaseHelper = ContactDatabaseHelper();
  String appBarTitle;
  Contact contact;
  List<Contact> contactList;
  int count = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController dobController = TextEditingController();
   _contactDetailState(this.contact, this.appBarTitle);
  @override
  Widget build(BuildContext context) {
    
    nameController.text = contact.name;
    phoneController.text = contact.phone;
    if (contactList == null) {
      contactList = List<Contact>();
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
                  child: TextField(
                    controller: nameController,
                    onChanged: (value) {
                      updateName();
                    },
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: phoneController,
                    onChanged: (value) {
                      updatePhone();
                    },
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: emailController,
                    onChanged: (value) {
                      updateEmail();
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: whatsappController,
                    onChanged: (value) {
                      updateWhatsapp();
                    },
                    decoration: InputDecoration(
                      labelText: 'Whatsapp Number',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: addressController,
                    onChanged: (value) {
                      updateAddress();
                    },
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: dobController,
                    onChanged: (value) {
                      updateDOB();
                    },
                    decoration: InputDecoration(
                      labelText: 'DOB',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
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
                      value: getPriorityAsString(contact.relation),
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

  void moveLastPage() {
    Navigator.pop(context, true);
  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Family':
        contact.relation = 1;
        break;
      case 'Friend':
        contact.relation = 2;
        break;
      case 'Colleagues':
        contact.relation = 3;
        break;
      case 'Work':
        contact.relation = 4;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
      case 3:
        priority = _priorities[2];
        break;
      case 4:
        priority = _priorities[3];
        break;
    }
    return priority;
  }

  void updateName() {
    contact.name = nameController.text;
  }

   void updatePhone() {
    contact.phone = phoneController.text;
  }

   void updateAddress() {
    contact.address= addressController.text;
  }

   void updateWhatsapp() {
    contact.whatsapp = whatsappController.text;
  }

  void updateEmail() {
    contact.email = emailController.text;
  }

  void updateDOB() {
    contact.dob = dobController.text;
  }

  // save data to database
  void _save() async {
    moveLastPage();
    int result;
    if (contact.id != null) {
      result = await _databaseHelper.updateContact(contact);
    } else {
      result = await _databaseHelper.insertContact(contact);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  //delete
  void _delete() async {
    moveLastPage();
    if (contact.id == null) {
      _showAlertDialog('Status', 'No Note Was Deleted');
      return;
    }
    int result = await _databaseHelper.deleteContact(contact.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = _databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Contact>> contactListFuture = _databaseHelper.getContactList();
      contactListFuture.then((contactList) {
        setState(() {
          this.contactList = contactList;
          this.count = contactList.length;
        });
      });
    });
  }
}
