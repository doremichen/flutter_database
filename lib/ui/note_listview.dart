///
/// List view widget
///
import 'package:flutter/material.dart';

import 'package:flutter_database_app/model/my_note.dart';
import 'package:flutter_database_app/util/my_database_helper.dart';

import 'note_screen.dart';

class MyListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _MyListViewState();
  }

}

class _MyListViewState extends State<MyListView> {

  List<MyNote> _list = List<MyNote>();
  MydbHelper _helper = MydbHelper();


  @override
  void initState() {
    super.initState();

    _helper.getAllNotes().then((notes) {
      setState(() {
        notes.forEach((note) {
          _list.add(MyNote.fromMap(note));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My note list view",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Note list"),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: _list.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    Divider(height: 10.0, color: Colors.red,),
                    ListTile(
                      title: Text("${_list[index].title}", style: TextStyle(fontSize: 24.0, color: Colors.deepOrangeAccent),),
                      subtitle: Text("${_list[index].description}", style: TextStyle(fontSize: 18.0, fontStyle: FontStyle.italic),),
                      leading: Column(
                        children: <Widget>[
                          Padding(padding: const EdgeInsets.all(10.0),),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 15.0,
                            child: Text("${_list[index].id}", style: TextStyle(fontSize: 22.0, color: Colors.white),),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle),
                            onPressed: () {
                              _deleteNote(context, _list[index], index);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        _navigateToNote(context, _list[index]);
                      },
                    ),
                  ],
                );
              }
          ),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            tooltip: "Add note",
            onPressed: () {
              _addNote(context);
            }
        ),
      ),
    );
  }


  // Private method =====================

  void _addNote(BuildContext context) async {
      String result = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => NoteItemScreen(MyNote("", "")),));

      // Check result
      if (result == "Save") {
        _helper.getAllNotes().then((notes) {
            setState(() {
              _list.clear();
              notes.forEach((note) {
                _list.add(MyNote.fromMap(note));
              });
            });
        });
      }
  }

  void _deleteNote(BuildContext context, MyNote note, int id) async {
    _helper.deleteNote(note.id).then((_) {
      setState(() {
        _list.removeAt(id);
      });
    });
  }

  void _navigateToNote(BuildContext context, MyNote note) async {
    String result = await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteItemScreen(note)));

    if (result == "Update") {
      _helper.getAllNotes().then((notes) {
        setState(() {
          _list.clear();
          notes.forEach((note) {
            _list.add(MyNote.fromMap(note));
          });
        });
      });
    }
  }


}