class Player {
  var name;
  var level;
  var profession;
  var status;            // online status
  var world;
  var comment;
  var accountStatus;     // premium or free account
  var guild;
  var house;
  var sex;
  var residence;
  var lastLogin;
  var position;          // player, Gamemaster etc
  var tasksDone;         // # of tasks done
  var logo;
  List<dynamic> latestDeaths;
  List<dynamic> latestKills;
  List<dynamic> taskList;

  Player.fromMap(Map<String, dynamic> map)  {
    name = map['name'];
    level = map['level'];
    profession = map['profession'];
    status = map['status'];
    world = map['world'];
    comment = map['comment'];
    accountStatus = map['account status'];
    guild = map['guild'];
    house = map['house'];
    sex = map['sex'];
    residence = map['residence'];
    lastLogin = map['last login'];
    position = map['position'];
    tasksDone = map['tasks_done'];
    logo = map['logo'];
    latestDeaths = map['Latest deaths'];
    latestKills = map['Latest kills'];
    taskList = map['task_list'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'level':level,
      'profession': profession,
      'status': status,
      'world': world,
      'comment': comment,
      'account status': accountStatus,
      'guild': guild,
      'house': house,
      'sex': sex,
      'residence': residence,
      'last login': lastLogin,
      'position': position,
      'tasks_done': tasksDone,
      'logo': logo,
      'Latest deaths': latestDeaths,
      'Latest kills': latestKills,
      'task_list': taskList
    };
  }

  @override
  String toString() => "Player<$name:$level:$profession:$world:$status>";
}