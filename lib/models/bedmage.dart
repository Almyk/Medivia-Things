import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class Bedmage extends Equatable {
  final String name;
  final String timeLeft;

  Bedmage({@required this.name, @required this.timeLeft}) : super([name, timeLeft]);

  Bedmage.fromMap(Map map)
  : this.name = map['name'],
    this.timeLeft = map['time_left'];

  Map<String, dynamic> toMap(Bedmage bedmage) {
    return {
      'name': name,
      'time_left': timeLeft
    };
  }
}