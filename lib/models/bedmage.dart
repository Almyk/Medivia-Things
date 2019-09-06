import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Bedmage extends Equatable {
  final String name;
  final int interval;
  String lastLogin;
  int timeLeft;

  Bedmage({@required this.name, @required this.interval})
      : super([name, interval]);

  Bedmage.fromMap(Map map)
      : this.name = map['name'],
        this.interval = map['interval'],
        super([map['name'], map['interval']]);

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
    }

    timeLeft = interval - number;
  }
}
