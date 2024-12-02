class Character {
  int? id;
  String name;
  int points;

  Character({ this.id, required this.name, required this.points});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['points'] = points;
    return map;
  }

  //from map
  Character.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        points = map['points'];
}
