import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:medivia_things/models/player.dart';
import 'package:medivia_things/utils/constants.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class Bedmage extends Equatable {
  String name;
  int interval;
  int logoutTime;
  int timeLeft;
  bool online;
  bool notified;

  Bedmage(
      {@required this.name,
      @required this.interval,
      this.logoutTime = -1,
      this.timeLeft = -1,
      this.online = false,
      this.notified = false})
      : super([name, interval, logoutTime, timeLeft]);

  Bedmage.fromMap(Map map)
      : this.name = map['name'],
        this.interval = map['interval'],
        this.logoutTime = map['logout_time'],
        this.timeLeft = map['time_left'],
        this.online = map['online'] == 1 ? true : false,
        this.notified = map['notified'] == 1 ? true : false,
        super([
          map['name'],
          map['interval'],
          map['logout_time'],
          map['time_left'],
          map['online'],
          map['notified']
        ]);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'interval': interval,
      'logout_time': logoutTime,
      'time_left': timeLeft,
      'online': online,
      'notified': notified
    };
  }

  bool calculateTimeLeft(Player player) {
    bool due = false;
    if (online && player.status == "Offline") {
      // was online and is now offline
      online = false;
      notified = false;
      print("Bedmage $name logged out");
      logoutTime = DateTime.now().millisecondsSinceEpoch;
      timeLeft = interval; // set timeleft to original interval
    } else if (player.status == "Online") {
      // bedmage is online
      online = true;
      notified = false;
      timeLeft = -1;
    } else {
      // bedmage is offline
      int time = DateTime.now().millisecondsSinceEpoch;

      int theoLogoutTime = theoreticalLogoutTime(player.lastLogin, time);

      if (logoutTime < theoLogoutTime) {
        // logged in and out without us noticing
        logoutTime = theoLogoutTime;
      }

      var _timeLeft = interval - ((time - logoutTime) ~/ (60 * 1000));

      if (_timeLeft > 0) {
        timeLeft = _timeLeft;
        notified = false;
      } else {
        timeLeft = 0;
        if (!notified) {
          due = true;
          notified = true;
        }
      }
    }
    // TODO add to DB here
    return due;
  }

  int theoreticalLogoutTime(String lastLogin, int time) {
    List<String> _lastLogin = lastLogin.split(" ");
    int number = int.tryParse(_lastLogin[0]);
    int theoLogoutTime;

    if (['second', 'seconds'].contains(_lastLogin[1])) {
      theoLogoutTime = time - (number * 1000);
    } else if (['minute', 'minutes'].contains(_lastLogin[1])) {
      theoLogoutTime = time - (number * 60 * 1000);
    } else if (['hour', 'hours'].contains(_lastLogin[1])) {
      theoLogoutTime = time - (number * 60 * 60 * 1000);
    } else {
      theoLogoutTime = -1;
    }

    return theoLogoutTime;
  }
}

class BedmageProvider {
  static Database _db;

  Future<Database> get database async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future initDB() async {
    String path = p.join(await getDatabasesPath(), "bedmage_db");
    _db = await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute("create table $bedmageTableName ("
        "name text primary key,"
        "interval integer,"
        "logout_time integer,"
        "time_left integer,"
        "online integer,"
        "notified integer)");
  }

  Future<int> insertBedmage(Bedmage bedmage) async {
    final db = await database;
    int result = await db.insert(bedmageTableName, bedmage.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<Bedmage>> getAllBedmages() async {
    final db = await database;
    var result = await db.query(bedmageTableName, orderBy: "name ASC");

    List<Bedmage> bedmageList =
        result.isNotEmpty ? result.map((b) => Bedmage.fromMap(b)).toList() : [];
    return bedmageList;
  }

  Future deleteBedmage(String name) async {
    final db = await database;
    await db.delete(bedmageTableName, where: "name = ?", whereArgs: [name]);
  }
}
