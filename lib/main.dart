
import 'package:flutter/material.dart';

import 'ContactKeeper/ContactList.dart';
import 'NoteKeeper/NoteList.dart';

void main() => runApp(
      MyApp(),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite',
      debugShowCheckedModeBanner: false,
      home: noteList(),//NoteKeeper App
      // home:contactList(),// Login App
    );
  }
}
