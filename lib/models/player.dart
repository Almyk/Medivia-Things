class Player {
  final String name;
  final String level;
  final String profession;
  final String status;
  final String world;

  Player.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['level'] != null),
        assert(map['profession'] != null),
        assert(map['status'] != null),
        assert(map['world'] != null),
        name = map['name'],
        level = map['level'],
        profession = map['profession'],
        status = map['status'],
        world = map['world'];

  @override
  String toString() => "Player<$name:$level:$profession:$world:$status>";
}