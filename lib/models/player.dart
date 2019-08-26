import 'dart:async';
import 'package:medivia_things/utils/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Player {
  String name;
  String level;
  String profession;
  String status; // online status
  String world;
  String comment;
  String accountStatus; // premium or free account
  String guild;
  String house;
  String sex;
  String residence;
  String lastLogin;
  String position; // player, Gamemaster etc
  int tasksDone; // # of tasks done
  String logo;
  List<dynamic> latestDeaths;
  List<dynamic> latestKills;
  List<dynamic> taskList;

  Player.fromMap(Map<String, dynamic> map, {bool db = false}) {
    // if this function was called from DB we use other names than web api
    if (db) {
      name = map['name'];
      level = map['level'];
      profession = map['profession'];
      status = map['status'];
      world = map['world'];
      comment = map['comment'];
      accountStatus = map['accountstatus'];
      guild = map['guild'];
      house = map['house'];
      sex = map['sex'];
      residence = map['residence'];
      lastLogin = map['lastLogin'];
      position = map['position'];
      tasksDone = map['tasksDone'];
      logo = map['logo'];
      

      String temp = map['latestDeaths'];
      latestDeaths = temp.split(',');

      temp = map['latestKills'];
      latestKills = temp.split(',');
      
      temp = map['taskList'];
      if (temp != null) {
        taskList = temp.split(',');
      }
    } else { // called from web api
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
  }

  Map<String, dynamic> toMap({bool db = true}) {
    return {
      'name': name,
      'level': level,
      'profession': profession,
      'status': status,
      'world': world,
      'comment': comment,
      'accountStatus': accountStatus,
      'guild': guild,
      'house': house,
      'sex': sex,
      'residence': residence,
      'lastLogin': lastLogin,
      'position': position,
      'tasksDone': tasksDone,
      'logo': logo,
      'LatestDeaths': db ? latestDeaths.join(',') : latestDeaths,
      'LatestKills': db ? latestKills.join(',') : latestKills,
      'taskList': db ? (taskList != null ? taskList.join(',') : null) : taskList
    };
  }

  void printTypes() {
    print(name.runtimeType);
    print(level.runtimeType);
    print(profession.runtimeType);
    print(status.runtimeType);
    print(world.runtimeType);
    print(comment.runtimeType);
    print(accountStatus.runtimeType);
    print(guild.runtimeType);
    print(house.runtimeType);
    print(sex.runtimeType);
    print(residence.runtimeType);
    print(lastLogin.runtimeType);
    print(position.runtimeType);
    print(tasksDone.runtimeType);
    print(logo.runtimeType);
    print(latestDeaths.runtimeType);
    print(latestKills.runtimeType);
    print(taskList.runtimeType);
  }

  @override
  String toString() => "Player<$name:$level:$profession:$world:$status>";
}

class PlayerProvider {
  static Database _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future initDB() async {
    String path = join(await getDatabasesPath(), "medivia_db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute("create table $vipListTableName ("
        "name text primary key,"
        "level text,"
        "profession text,"
        "status text,"
        "world text,"
        "comment text,"
        "accountStatus text,"
        "guild text,"
        "house text,"
        "sex text,"
        "residence text,"
        "lastLogin text,"
        "position text,"
        "tasksDone integer,"
        "logo text,"
        "latestDeaths text,"
        "latestKills text,"
        "taskList text)");
  }

  Future<int> insertNewVip(Player player) async {
    final db = await database;
    int result = await db.insert(vipListTableName, player.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<Player>> getAllVip() async {
    print("getAllVip");
    final db = await database;
    var result = await db.query(vipListTableName);

    List<Player> vipList = result.isNotEmpty
        ? result.map((p) => Player.fromMap(p, db: true)).toList()
        : [];
    return vipList;
  }
}
