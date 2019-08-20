import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {}

class ShowOnlineDestiny extends NavigationEvent {
  @override
  String toString() => "Navigation: Show Online List for Destiny";
}

class ShowOnlineLegacy extends NavigationEvent {
  @override
  String toString() => "Navigation: Show Online List for Legacy";
}

class ShowOnlinePendulum extends NavigationEvent {
  @override
  String toString() => "Navigation: Show Online List for Pendulum";
}

class ShowOnlineProphecy extends NavigationEvent {
  @override
  String toString() => "Navigation: Show Online List for Prophecy";
}

class ShowOnlineStrife extends NavigationEvent {
  @override
  String toString() => "Navigation: Show Online List for Strife";
}

class ShowVipList extends NavigationEvent {
  @override
  String toString() => "Navigation: Show Vip List";
}