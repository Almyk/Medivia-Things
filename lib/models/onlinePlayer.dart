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
