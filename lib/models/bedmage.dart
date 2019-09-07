import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:medivia_things/models/player.dart';

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
        this.online = map['online'],
        this.notified = map['notified'],
        super([
          map['name'],
          map['interval'],
          map['logout_time'],
          map['time_left'],
          map['online'],
          map['notified']
        ]);

  Map<String, dynamic> toMap(Bedmage bedmage) {
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
    if (name != player.name) {
      // TODO delete bedmage
      name = player.name;
    }
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
          // TODO create a notification
          due = true;
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
