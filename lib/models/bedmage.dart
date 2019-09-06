import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Bedmage extends Equatable {
  final String name;
  final int interval;
  String lastLogin;
  String timeLeft;

  Bedmage(
      {@required this.name,
      @required this.interval,
      this.lastLogin = "",
      this.timeLeft = "Calculating..."})
      : super([name, interval, lastLogin, timeLeft]);

  Bedmage.fromMap(Map map)
      : this.name = map['name'],
        this.interval = map['interval'],
        this.lastLogin = map['last_login'],
        this.timeLeft = map['time_left'],
        super([
          map['name'],
          map['interval'],
          map['last_login'],
          map['time_left']
        ]);

  Map<String, dynamic> toMap(Bedmage bedmage) {
    return {
      'name': name,
      'interval': interval,
      'last_login': lastLogin,
      'time_left': timeLeft
    };
  }

  calculateTimeLeft() {
    int minutes = 0;
    List<String> temp = lastLogin.split(' ');
    var number = int.tryParse(temp[0]);

    if (['hour', 'hours'].contains(temp[1])) {
      minutes = 60 * number;
    } else if (['minute', 'minutes'].contains(temp[1])) {
      minutes = number;
    } else if (['day', 'days'].contains(temp[1])) {
      minutes = 60 * 24 * number;
    }

    var _timeleft = interval - minutes;
    if (_timeleft <= 0) {
      timeLeft = "Due";
    } else {
      timeLeft = "$_timeleft min";
    }
  }
}
