class OnlinePlayer {
  final String name;
  final int level;
  final String vocation;
  final String login;

  OnlinePlayer.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        assert(map['level'] != null),
        assert(map['vocation'] != null),
        assert(map['login'] != null),
        name = map['name'],
        level = map['level'],
        vocation = map['vocation'],
        login = map['login'];

  @override
  String toString() => "Record<$name:$level:$vocation:$login>";
}

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