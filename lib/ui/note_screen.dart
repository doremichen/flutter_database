///
/// note item screen
///
import 'package:flutter/material.dart';

import 'package:flutter_database_app/model/my_note.dart';
import 'package:flutter_database_app/util/my_database_helper.dart';

class NoteItemScreen extends StatefulWidget {
  final MyNote _note;

  NoteItemScreen(@required this._note);

  @override
  State<StatefulWidget> createState() {
    return _NoteItemScreenState();
  }

}

class _NoteItemScreenState extends State<NoteItemScreen> {

  MydbHelper _dbHelper = MydbHelper();

  // Text edit controller
  TextEditingController _titleController;
  TextEditingController _descriptionController;


  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget._note.title);
    _descriptionController = TextEditingController(text: widget._note.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hi my note"),),
      body: Container(
        margin: const EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            Padding(padding: const EdgeInsets.all(5.0),),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            Padding(padding: const EdgeInsets.all(5.0),),
            RaisedButton(
              child: (widget._note.id != null)? Text("Update"): Text("Add"),
              onPressed: () {
                if (widget._note.id != null) {
                  _dbHelper.updateNote(MyNote.fromMap({
                        "id": widget._note.id,
                        "title": _titleController.text,
                        "description": _descriptionController.text
                      }
                    )
                  ).then((_) {
                    Navigator.pop(context, "Update");
                  });
                } else {
                  _dbHelper.saveNote(MyNote(_titleController.text, _descriptionController.text)).then((_) {
                    Navigator.pop(context, "Save");
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

}