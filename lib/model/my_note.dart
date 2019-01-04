///
/// My note
///

class MyNote {
  int _id;
  String _title;
  String _description;

  MyNote(this._title, this._description);

  // Build object data mapping
  MyNote.map(dynamic obj) {
    this._id = obj['id'];
    this._title = obj['title'];
    this._description = obj['description'];
  }

  // Get data
  int get id => _id;
  String get title => _title;
  String get description => _description;

  // Build mapping table
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    return map;
  }

  // Get data from mapping table
  MyNote.fromMap(Map<String, dynamic> map) {
      this._id = map['id'];
      this._title = map['title'];
      this._description = map['description'];
  }

}