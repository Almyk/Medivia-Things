class Player {
  final String name;
  final String level;
  final String profession;
  final String status;            // online status
  final String world;
  final String comment;
  final String accountStatus;     // premium or free account
  final String guild;
  final String house;
  final String sex;
  final String residence;
  final String lastLogin;
  final String position;          // player, Gamemaster etc
  final String tasksDone;         // # of tasks done
  final String logo;
  final List<String> latestDeaths;
  final List<String> latestKills;
  final List<String> taskList;

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
        world = map['world'],
        comment = map['comment'],
        accountStatus = map['account status'],
        guild = map['guild'],
        house = map['house'],
        sex = map['sex'],
        residence = map['residence'],
        lastLogin = map['last login'],
        position = map['position'],
        tasksDone = map['tasks_done'],
        logo = map['logo'],
        latestDeaths = map['Latest deaths'],
        latestKills = map['Latest kills'],
        taskList = map['task_list'];

  @override
  String toString() => "Player<$name:$level:$profession:$world:$status>";
}