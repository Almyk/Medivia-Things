import 'package:equatable/equatable.dart';

abstract class OnlineState extends Equatable {}

class ShowOnlinePlayers extends OnlineState {
  @override
  toString() => "Show Online Players";
}

class UpdatePlayerCounter extends OnlineState {
  @override
  toString() => "Update Player Counter";
}
