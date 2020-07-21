class Character{
  int _id;
  String _name;
  int _points;

  Character(this._name, this._points);
  Character.withId(this._id, this._name, this._points);

  int get id => _id;
  String get name => _name;
  int get points => _points;

  set name(String newName) {
    _name = newName;
  }

  set points(int newPoints) {
    _points = newPoints;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if(id != null) {
      map['id'] =_id;
    }
    map['name'] = _name;
    map['points'] = _points;

    return map;
  }

  Character.fromObject(dynamic o) {
    this._id = o['id'];
    this._name = o['name'];
    this._points = o['points'];
  }
}